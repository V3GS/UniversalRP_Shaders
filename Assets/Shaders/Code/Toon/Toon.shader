// Based on the following tutorial: https://roystan.net/articles/toon-shader/
Shader "V3GS/Toon"
{
    Properties
    {
        [MainTexture]
        _BaseMap("Base Map", 2D) = "white"{}
        [MainColor]
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
        _SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
        _Glossiness("Glossiness", Float) = 32
        _RimColor("Rim Color", Color) = (1,1,1,1)
        _RimAmount("Rim Amount", Range(0, 1)) = 0.716
        _RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normal       : NORMAL;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float3 normal       : NORMAL;
                float2 uv           : TEXCOORD0;
                float3 viewDir      : TEXCOORD1;
            };

            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
            CBUFFER_END

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            float4 _AmbientColor;
            float4 _SpecularColor;
            float4 _RimColor;
            float _Glossiness;
            float _RimAmount;
            float _RimThreshold;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.normal      = TransformObjectToWorldNormal(IN.normal);
                OUT.uv          = TRANSFORM_TEX(IN.uv, _BaseMap);
                OUT.viewDir     = GetWorldSpaceViewDir(IN.positionOS);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

                Light mainLight = GetMainLight();

                float3 normal = normalize(IN.normal);
                float NdotL = dot(mainLight.direction, normal);
                float3 viewDir = normalize(IN.viewDir);

                float lightIntensity = smoothstep(0, 0.01, NdotL);
                float4 light = lightIntensity * float4(mainLight.color, 1.0f);

                float3 halfVector = normalize(_MainLightPosition + viewDir);
                float NdotH = dot(normal, halfVector);
                float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);

                float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
                float4 specular = specularIntensitySmooth * _SpecularColor;

                float4 rimDot = 1 - dot(viewDir, normal);

                float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
                rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
                float4 rim = rimIntensity * _RimColor;

                return color * _BaseColor * (_AmbientColor + light + specular + rim);
            }
            ENDHLSL
        }
    }
}