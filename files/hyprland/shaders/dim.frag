// Screen Dimming

#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;

out vec4 fragColor;

void main()
{
  fragColor = texture(tex, v_texcoord) * 0.3;
}
