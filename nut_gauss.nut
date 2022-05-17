function gaussbilinear(kernel, sigma){
   local halfkern = (kernel-1)*0.5 + 1

   //build u0 and w0, initial vectors of sampling points and weights
   local u0 = array (halfkern,0)
   local w0 = array (halfkern,0)
   foreach (i, item in u0){ 
      u0[i] = i
   }
   local kersum = 0
   foreach (i, item in w0){
      w0[i] = (1/(sqrt(2.0*3.14)*sigma)) * pow (2.7182, -0.5 * (u0[i]/sigma)*(u0[i]/sigma) )
      if (i == 0) kersum = kersum + w0[i]
      else kersum = kersum + 2 * w0[i]
   }
   foreach (i, item in w0){
      w0[i] = w0[i] / kersum
   }

   local halfhalfkern = (halfkern - 1)*0.5 + 1
   local u1 = array (halfhalfkern,0)
   local w1 = array (halfhalfkern,w0[0])

   for (local i = 1 ; i < u1.len(); i++){
      w1[i] = w0[i*2 - 1] + w0[i*2]
      u1[i] = ( (u0[i*2 - 1] * w0[i*2 - 1]) + (u0[i*2] * w0[i*2]) ) / w1[i]
   }
/*
   foreach (i,item in u0){
      print (u0[i]+ " "+w0[i]+"\n")
   }
   print ("\n")
   foreach (i,item in u1){
      print (u1[i]+ " "+w1[i]+"\n")
   }
*/
   return ({
      u = u1
      w = w1
   })
}

function gaussshader (shaderin, kernel, sigma, offsetx, offsety){
   local gdata = gaussbilinear (kernel,sigma)
   shaderin.set_texture_param ("texture")
      shaderin.set_param ("offsetfactor", offsetx, offsety)
   if (kernel == 5) {
      shaderin.set_param ("w0", gdata.w[0], gdata.w[1])
      shaderin.set_param ("u0", gdata.u[0], gdata.u[1])
   }
   else if (kernel == 9) {
      shaderin.set_param ("w0", gdata.w[0], gdata.w[1], gdata.w[2])
      shaderin.set_param ("u0", gdata.u[0], gdata.u[1], gdata.u[2])
   }
   else if (kernel == 13) {
      shaderin.set_param ("w0", gdata.w[0], gdata.w[1],gdata.w[2],gdata.w[3])
      shaderin.set_param ("u0", gdata.u[0], gdata.u[1],gdata.u[2],gdata.u[3])
   }
}

// INDEX:
// shader_bg: 3 (26px, 9.0, 2.2)
// gradient: 1 (8px, 5, 2.0)
// logo shadow: 1 (98px, 5, 1.75)
// data shadow: 4 (400px, 9, 3.0)
// frost: 3 - downsample to 64x64 (320px, 55, 12.5)
