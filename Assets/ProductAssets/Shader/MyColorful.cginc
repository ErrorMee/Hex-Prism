#if !defined(MY_COLORFUL)
#define MY_COLORFUL



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

struct Input
{
    float2 uv_MainTex;
    float3 worldPos;
    fixed3 worldNormal : TEXCOORD0;
};

void vert(inout appdata_full v, out Input data) {
    UNITY_INITIALIZE_OUTPUT(Input, data);

    data.worldNormal = UnityObjectToWorldNormal(v.normal);
}

fixed4 GetColorful(Input IN)
{
    float height = IN.worldPos.y +
        sin(length(IN.worldPos - half3(100, 1000, 100)) * 8) * _UnitHeight / 16 +
        (sin(IN.worldPos.x) + cos(IN.worldPos.z));

    int level = ceil(height / _UnitHeight);//-2 -1 0 1 2
    level = abs(level);//2 1 0 1 2
    level = level % 8.0;
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
    //return intColor;
    //1 0 1
    float frac101 = abs(abs(frac(height / _UnitHeight)) - 0.5) * 2;
    float fadeRang = 0.1;
    float frac101P = clamp(frac101 - (1 - fadeRang), 0, 1);
    float fade = frac101P / fadeRang;

    return lerp(intColor, 1, fade);
}
#endif