Shader "V3GS/Transforms/Translate vertex"
{
    Properties
    {
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _Amplitude ("Movement amplitude", Range(0.0, 1.0)) = 0
        _Speed ("Movement speed", Range(0.0, 10.0)) = 0
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

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float2 uv           : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uv           : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            
            float _Amplitude;
            float _Speed;

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
            CBUFFER_END
            
            float4 Translate(float value, float4 vertex)
            {
                // Generating a sin wave movement
                float movementValue = _Amplitude * sin(_Speed * value) + _Amplitude;

                float4x4 translationMatrix = float4x4(
                    1, 0, 0, 0,
                    0, 1, 0, movementValue,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                );

                return mul(translationMatrix, vertex);
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                IN.positionOS = Translate(_Time.y, IN.positionOS);
                
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
                return color;
            }
            ENDHLSL
        }
    }
}
