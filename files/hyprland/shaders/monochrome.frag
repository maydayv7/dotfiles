// Monochrome filter

#version 300 es
precision mediump float;

in vec2 v_texcoord;
uniform sampler2D tex;

out vec4 fragColor;

void main()
{
   vec4 pixColor = texture(tex, v_texcoord);

   // Check https://en.wikipedia.org/wiki/Grayscale#Luma_coding_in_video_systems for which one to choose
   float lum = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114)); // BT.601
   // float lum = dot(pixColor.rgb, vec3(0.2126, 0.7152, 0.0722)); // BT.709
   // float lum = dot(pixColor.rgb, vec3(0.2627, 0.6780, 0.0593)); // BT.2100

   fragColor = vec4(vec3(lum), pixColor.a);
}
