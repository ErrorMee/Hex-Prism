Shader "Custom/PrismCliff"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _UnitHeight("UnitHeight", Range(0,1)) = 0.3

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
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _UnitHeight;

        fixed4 _HeightColor0;
        fixed4 _HeightColor1;
        fixed4 _HeightColor2;
        fixed4 _HeightColor3;
        fixed4 _HeightColor4;
        fixed4 _HeightColor5;
        fixed4 _HeightColor6;
        fixed4 _HeightColor7;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        float random(float seed) {
            return frac(sin(dot(float2(seed, 0.5), float2(12.9898, 78.233))) * 43758.5453123);
        }

        fixed4 GetAlbedoColor(Input IN)
        {
            float height = IN.worldPos.y + sin(IN.uv_MainTex.x * 3.1415926 * 2 * 16) * _UnitHeight / 16;
            
            height = step(0, height) * height;
            int level = ceil(height / _UnitHeight);

            level = (1- step(1, level)) + level;
            level = (1 - step(9, level)) * level + step(9, level) * 8;
            //step(a,b) if a>b return 0
            //return tex2D(_MainTex, IN.uv_MainTex);
            return step(1, level) * step(level, 1) * _HeightColor0
                + step(2, level) * step(level, 2) * _HeightColor1
                + step(3, level) * step(level, 3) * _HeightColor2
                + step(4, level) * step(level, 4) * _HeightColor3
                + step(5, level) * step(level, 5) * _HeightColor4
                + step(6, level) * step(level, 6) * _HeightColor5
                + step(7, level) * step(level, 7) * _HeightColor6
                + step(8, level) * step(level, 8) * _HeightColor7;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = GetAlbedoColor(IN);
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
