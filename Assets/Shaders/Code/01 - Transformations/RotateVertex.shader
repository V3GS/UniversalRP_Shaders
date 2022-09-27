Shader "V3GS/Transforms/Rotate vertex"
{
    Properties
    {
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        [KeywordEnum(None, X, Y, Z)]
        _RotationAxis("Rotation Axis", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma multi_compile _ROTATIONAXIS_NONE _ROTATIONAXIS_X _ROTATIONAXIS_Y _ROTATIONAXIS_Z

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
            
            float4 Rotate(float angle, float4 vertex)
            {
                float4x4 rotationMatrix = float4x4(
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                );

                #if _ROTATIONAXIS_X
                    rotationMatrix = float4x4(
                        1,			0,              0,				0,
                        0,	        cos(angle),     -sin(angle),	0,
                        0,          sin(angle),     cos(angle),		0,
                        0,			0,              0,				1
                    );
                #endif

                #if _ROTATIONAXIS_Y
                    rotationMatrix = float4x4(
                        cos(angle),	0,	            -sin(angle),	0,
                        0,			1,	            0,				0,
                        sin(angle), 0,	            cos(angle),		0,
                        0,			0,	            0,				1
                    );
                #endif

                #if _ROTATIONAXIS_Z
                    rotationMatrix = float4x4(
                        cos(angle),	-sin(angle),	0,	            0,
                        sin(angle), cos(angle),		0,	            0,
                        0,			0,				1,	            0,
                        0,			0,				0,	            1
                    );
                #endif

                return mul(rotationMatrix, vertex);
            }

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                IN.positionOS = Rotate(_Time.y, IN.positionOS);
                
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
