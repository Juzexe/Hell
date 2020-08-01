#version 420 core

layout (location = 0) in vec3 a_Position;
layout (location = 2) in vec2 a_Texcoord;

uniform mat4 u_MatrixProjection;
uniform mat4 u_MatrixView;
uniform mat4 u_MatrixWorld;
uniform mat4 u_MatrixInverseWorld;

layout (binding = 0) uniform sampler2D u_PosTex;
layout (binding = 1) uniform sampler2D u_NormTex;

//uniform float u_BoundingMax;
//uniform float u_BoundingMin;
//uniform float u_Speed;
//uniform int u_NumOfFrames;
//uniform vec4 u_HeightOffset;
uniform float u_Time;
uniform vec3 u_WorldSpaceCameraPos;

out vec3 v_WorldNormal;
out vec3 v_ViewDir;

float LinearToGammaSpaceExact (float value)
{
    if (value <= 0.0F)
        return 0.0F;
    else if (value <= 0.0031308F)
        return 12.92F * value;
    else if (value < 1.0F)
        return 1.055F * pow(value, 0.4166667F) - 0.055F;
    else
        return pow(value, 0.45454545F);
}

vec3 LinearToGammaSpace (vec3 linRGB)
{
   return vec3(LinearToGammaSpaceExact(linRGB.r), LinearToGammaSpaceExact(linRGB.g), LinearToGammaSpaceExact(linRGB.b));
}

vec3 ObjSpaceViewDir(vec3 v )
{
    //vec3 objSpaceCameraPos = mul(u_MatrixWorld, vec4(u_WorldSpaceCameraPos.xyz, 1)).xyz;
    vec3 objSpaceCameraPos = (u_MatrixWorld, vec4(u_WorldSpaceCameraPos.xyz, 1)).xyz;
    return objSpaceCameraPos - v.xyz;
}

void main() {

    //float currentSpeed = u_Speed / u_NumOfFrames;

 // float  u_Time = 0;

    int u_NumOfFrames = 81;
    int u_Speed = 35;
    int u_BoundingMax = 144;
    int u_BoundingMin = 116;
    vec3 u_HeightOffset = vec3(-45.4, -26.17, 12.7);

    u_BoundingMax = 1;
    u_BoundingMin = -1;
    u_HeightOffset = vec3(0, 0, 0);

    float currentSpeed = 1.0f / (u_NumOfFrames / u_Speed);
    float timeInFrames = ((ceil(fract(-u_Time * currentSpeed) * u_NumOfFrames)) / u_NumOfFrames) + (1.0 / u_NumOfFrames);

    vec3 v = a_Position;
    vec2 uv = a_Texcoord;

    timeInFrames = u_Time;//
   // timeInFrames = 0.166;

    vec4 texturePos = textureLod(u_PosTex, vec2(uv.x, (timeInFrames + uv.y)), 0);
    vec4 textureNorm = textureLod(u_NormTex, vec2(uv.x, (timeInFrames + uv.y)), 0);

    //float expand = u_BoundingMax - u_BoundingMin;
    //texturePos.xyz *= expand;
    //texturePos.xyz += u_BoundingMin;
    //texturePos.x *= -1;

    //v = texturePos.xzy * 20000;
        
   // texturePos *= (0.0001);

   // v = texturePos.xzy;
   // v += u_HeightOffset.xyz;
    

  //  gl_Position = u_MatrixProjection * u_MatrixView * u_MatrixWorld * vec4(a_Position, 1.0);
    
    v = texturePos.xzy * 25000;

    v_WorldNormal = textureNorm.xzy * 2 - 1;
    v_WorldNormal.x *= -1;

    v_ViewDir = ObjSpaceViewDir(v);

    gl_Position = u_MatrixProjection * u_MatrixView * u_MatrixWorld * vec4(v, 1.0);
                
   // v_WorldNormal = textureNorm.xyz * 2 - vec3(1, 1, 1); 
    //v_WorldNormal.x = -v_WorldNormal.x;
    
    //v_ViewDir = (u_MatrixInverseWorld * vec4(u_WorldSpaceCameraPos, 1.0)).xyz - vertexPos;

}