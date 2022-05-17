#version 120
//
// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//   by Timothy Lottes
//
// This is more along the style of a really good CGA arcade monitor.
// With RGB inputs instead of NTSC.
// The shadow mask example has the mask rotated 90 degrees for less chromatic aberration.
//
// Converted to MAME and AttractMode FE by Luke-Nukem (admin@garagearcades.co.nz)
//  http://www.garagearcades.co.nz
//
// Modifications for AttractMode FE by Chris Van Graas (@chrisvangraas)
//
// Comment these out to disable the corresponding effect.

// Handle layout rotation in AttractMode FE
#define ROTATED
// CRT Screen Shape
#define CURVATURE
// Saturation and Tint
#define YUV
// Expands contrast and makes image brighter but causes clipping.
#define GAMMA_CONTRAST_BOOST


#pragma optimize (on)
#pragma debug (off)

// FOR CRT GEOM
#define FIX(c) max(abs(c), 1e-5);
#define TEX2D(c) texture2D(texture, (c)).rgb
varying vec2  texCoord;
varying float U;
varying float W;
varying vec3 YUVr;
varying vec3 YUVg;
varying vec3 YUVb;

uniform float aperature_type;
uniform float distortion;
uniform float cornersize;
uniform float cornersmooth;

uniform vec3 vignettebase;
//uniform float CRTgamma;
//uniform float monitorgamma;

//Normal MAME GLSL Uniforms
uniform sampler2D texture;
uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

// Filter Variables
uniform float hardScan;
uniform float maskDark;
uniform float maskLight;
uniform float hardPix;
// YUV Variables
uniform float saturation;
uniform float tint;
// GAMMA Variables
uniform float blackClip;
uniform float brightMult;
// AttractMode FE Variables
uniform float rotated;
uniform float vert;
uniform vec3 hsv;

const vec3 gammaBoost = vec3(1.0/1.2, 1.0/1.2, 1.0/1.2);//An extra per channel gamma adjustment applied at the end.

//Here are the Tint/Saturation/GammaContrastBoost Variables.  Comment out "#define YUV" and "#define GAMMA_CONTRAST_BOOST" to disable these altogether.

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c)
{
    float c_step = step (0.04045,c);
    return ( c_step * (pow((c+0.055) / 1.055,2.4)) + (1.0-c_step)*(c / 12.92));
    //TEST97 return(c <= 0.04045) ? c / 12.92 : pow((c+0.055) / 1.055,2.4);
}
vec3 ToLinear(vec3 c)
{
    return vec3( ToLinear1(c.r), ToLinear1(c.g), ToLinear1(c.b) );
}

// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c)
{
    float c_step = step (0.0031308,c);
    return ( c_step * (1.055 * pow(c,0.41666) - 0.055) + (1.0-c_step)*(c * 12.92 ));
    //TEST97 return( c < 0.0031308 ? c * 12.92 : 1.055 * pow(c,0.41666) - 0.055);
}
vec3 ToSrgb(vec3 c)
{
    return vec3(ToSrgb1(c.r), ToSrgb1(c.g), ToSrgb1(c.b));
}

// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos, vec2 off)
{
    //TEST97
    /*
    pos = ((vert == 1.0) ? 
    ((floor(pos * color_texture_pow2_sz + off.yx) + 0.5) / color_texture_pow2_sz) 
    : 
    ((floor(pos * color_texture_pow2_sz + off) + 0.5) / color_texture_pow2_sz));
   */
    pos = vert * ((floor(pos * color_texture_pow2_sz + off.yx) + 0.5) / color_texture_pow2_sz) + (1.0 - vert) * ((floor(pos * color_texture_pow2_sz + off) + 0.5) / color_texture_pow2_sz);

   // if(max(abs(pos.x-0.5),abs(pos.y-0.5))>0.5)return vec3(0.0,0.0,0.0);
    vec4 t0 = texture2D(texture, pos.xy);
    vec3 hsv0 = rgb2hsv (t0.rgb);
    vec3 hsv1 = clamp(hsv0+hsv,vec3(0.0),vec3(1.0));
    t0.rgb = hsv2rgb (hsv1);

    return ToLinear(t0.rgb);
}

// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos)
{
    pos = pos * color_texture_pow2_sz;
    return -((pos - floor(pos)) - vec2(0.5));
}
    
// 1D Gaussian.
float Gaus(float pos,float scale)
{
    return exp2(scale * pos * pos);
}

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos,float off)
{
    vec3 b = Fetch(pos, vec2(-1.0, off));
    vec3 c = Fetch(pos, vec2( 0.0, off));
    vec3 d = Fetch(pos, vec2( 1.0, off));
    float dst = Dist(pos).x;
    // Convert distance to weight.

    float scale = hardPix;

    float wb = Gaus(dst - 1.0, scale);
    float wc = Gaus(dst + 0.0, scale);
    float wd = Gaus(dst + 1.0, scale);
    // Return filtered sample.
    return (b * wb + c * wc + d * wd) / (wb + wc + wd);
}

// 5-tap Gaussian filter along horz line.
vec3 Horz5(vec2 pos,float off)
{
    vec3 a = Fetch(pos, vec2(-2.0, off));
    vec3 b = Fetch(pos, vec2(-1.0, off));
    vec3 c = Fetch(pos, vec2( 0.0, off));
    vec3 d = Fetch(pos, vec2( 1.0, off));
    vec3 e = Fetch(pos, vec2( 2.0, off));
    //TEST97 float dst = (vert == 1.0 ? Dist(pos).y : Dist(pos).x);
    float dst = (vert * Dist(pos).y + (1.0-vert) * Dist(pos).x);
    // Convert distance to weight.

    float scale = hardPix;

    float wa = Gaus(dst - 2.0, scale);
    float wb = Gaus(dst - 1.0, scale);
    float wc = Gaus(dst + 0.0, scale);
    float wd = Gaus(dst + 1.0, scale);
    float we = Gaus(dst + 2.0, scale);
    // Return filtered sample.
    return (a * wa + b * wb + c * wc + d * wd + e * we) / (wa + wb + wc + wd + we);
}

// Return scanline weight.
float Scan(vec2 pos,float off)
{
    //TEST97 float dst = (vert == 1.0 ? Dist(pos).x : Dist(pos).y );
    float dst = (vert * Dist(pos).x + (1.0-vert)* Dist(pos).y );
    return Gaus(dst + off, hardScan);

}

// Allow nearest three lines to effect pixel.
vec3 Tri(vec2 pos)
{
    vec3 a = Horz3(pos, -1.0);
    vec3 b = Horz5(pos, 0.0);
    vec3 c = Horz3(pos, 1.0);
    float wa = Scan(pos, -1.0);
    float wb = Scan(pos, 0.0);
    float wc = Scan(pos, 1.0);
    
    return a * wa + b * wb + c * wc;
}
    
// Shadow mask.
vec3 Mask(vec2 pos)
{
    pos.xy = floor(pos.xy * vec2(1.0, 0.5));
    pos.x += pos.y * 3.0;
    vec3 mask = vec3(maskDark, maskDark, maskDark);
    pos.x = fract(pos.x / 6.0);
    if (pos.x<0.333)
        mask.r = maskLight;
    else if (pos.x < 0.666)
        mask.g = maskLight;
    else 
        mask.b = maskLight;
    
    return (aperature_type * mask + (1.0 - aperature_type) * vec3(1.0));
    
}    
///////////////////////////////////////////////////////////////
/// CRT GEOM FUNCTIONS ///
// GIVES THE CURVE
vec2 radialDistortion(vec2 coord) {
    coord *= color_texture_pow2_sz / color_texture_sz;
    vec2 cc = coord - vec2(0.5);
    float dist = dot(cc, cc) * distortion;
    return (coord + cc * (1.0 + dist) * dist) * color_texture_sz / color_texture_pow2_sz;
}

float corner(vec2 coord)
{
    coord *= color_texture_pow2_sz / color_texture_sz;
    coord = (coord - vec2(0.5)) + vec2(0.5);
    coord = min(coord, vec2(1.0)-coord);
    vec2 cdist = vec2(cornersize);
    coord = (cdist - min(coord,cdist));
    float dist = sqrt(dot(coord,coord));
    return clamp((cdist.x-dist)*cornersmooth,0.0, 1.0);
}

float vignette(vec2 coord)
{
    //return 1.0;
    vec2 cdist = coord - vec2(0.5);
    float dist = sqrt(dot(cdist,cdist));
    return vignettebase.x + (1.0 - vignettebase.x) * (vignettebase.y - vignettebase.z*(dist*dist));
}

///////////////////////////////////////////////////////////////
void main(void)
{
  //  gl_FragColor.a = gl_Color.a;


#ifdef CURVATURE
    vec2 pos = radialDistortion(texCoord);//CURVATURE
    //FINAL//
 //       gl_FragColor.rgb = pow(pow(Tri(pos) , vec3(CRTgamma)),vec3(1.0 / monitorgamma)) * Mask(gl_FragCoord.xy) * vec3(corner(pos));

    gl_FragColor.rgb = vec3(vignette(pos)) * Tri(pos) * Mask(gl_FragCoord.xy) * vec3(corner(pos));
  //  gl_FragColor.a = gl_Color.a*(corner(pos));

#else
    vec2 pos = gl_TexCoord[0].xy;
    gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy);
#endif

#ifdef YUV
    gl_FragColor.rgb = vec3(dot(YUVr,gl_FragColor.rgb), dot(YUVg,gl_FragColor.rgb), dot(YUVb,gl_FragColor.rgb));
    gl_FragColor.rgb = clamp(ToSrgb(gl_FragColor.rgb), 0.0, 1.0);
#endif
  
#ifdef GAMMA_CONTRAST_BOOST
    gl_FragColor.rgb=brightMult*pow(gl_FragColor.rgb,gammaBoost )-vec3(blackClip);
#endif

gl_FragColor.a = corner(pos);
}
