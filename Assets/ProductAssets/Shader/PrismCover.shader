﻿Shader "Custom/PrismCover"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0

        _UnitHeight("UnitHeight", Range(0,4)) = 1

        _BGColor("BGColor", Color) = (1,1,1,1)

        _HeightColor0("HeightColor0", Color) = (1,1,1,1)
        _HeightColor1("HeightColor1", Color) = (1,1,1,1)
        _HeightColor2("HeightColor2", Color) = (1,1,1,1)
        _HeightColor3("HeightColor3", Color) = (1,1,1,1)
        _HeightColor4("HeightColor4", Color) = (1,1,1,1)
        _HeightColor5("HeightColor5", Color) = (1,1,1,1)
        _HeightColor6("HeightColor6", Color) = (1,1,1,1)
        _HeightColor7("HeightColor7", Color) = (1,1,1,1)

    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0
            #include "MyColorful.cginc"

            sampler2D _MainTex;

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            
            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)


            fixed4 GetCoverColor(Input IN)
            {
                if (IN.worldNormal.y > 0.9)
                {
                    //return lerp(_BGColor * tex2D(_MainTex, IN.uv_MainTex), GetColorful(IN), 0.2);
                    return lerp(_BGColor, GetColorful(IN), 0.2);
                }

                return GetColorful(IN);
            }
            
            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = GetCoverColor(IN);
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
