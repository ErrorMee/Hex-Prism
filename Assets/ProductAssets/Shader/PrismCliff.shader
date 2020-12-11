Shader "Custom/PrismCliff"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

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

        fixed4 _BGColor;

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

        fixed4 GetAlbedoColor(Input IN)
        {
            float height = IN.worldPos.y +
                sin(length(IN.worldPos - half3(100, 1000, 100)) * 8) * _UnitHeight / 16 +
                (IN.worldPos.x + IN.worldPos.z);
            
            int level = ceil(height / _UnitHeight);//-2 -1 0 1 2
            level = abs(level);//2 1 0 1 2
            level = level % 8;
            //step(a,b) if a>b return 0
            //return tex2D(_MainTex, IN.uv_MainTex);

            fixed4 intColor = 
                step(0, level) * step(level, 0) * _HeightColor0
                + step(1, level) * step(level, 1) * _HeightColor1
                + step(2, level) * step(level, 2) * _HeightColor2
                + step(3, level) * step(level, 3) * _HeightColor3
                + step(4, level) * step(level, 4) * _HeightColor4
                + step(5, level) * step(level, 5) * _HeightColor5
                + step(6, level) * step(level, 6) * _HeightColor6
                + step(7, level) * step(level, 7) * _HeightColor7;

            //1 0 1
            float frac101 = abs(abs(frac(height / _UnitHeight)) - 0.5) * 2;
            float fadeRang = 0.8;
            float frac101P = clamp(frac101 - (1 - fadeRang), 0, 1);
            float fade = frac101P / fadeRang;

            return lerp(intColor, _BGColor, fade);
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
