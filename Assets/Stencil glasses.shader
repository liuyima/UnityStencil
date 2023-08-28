Shader "Liu/Stencil glasses"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Glossiness("Smoothness", Float) = 0.5

		[IntRange]_Ref("ref",Range(0,255)) = 2
		[IntRange]_Comp("comp",Range(1,8)) = 0
		[IntRange]_Pass("pass",Range(0,7)) = 0
		[IntRange]_Fail("fail",Range(0,7)) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
			//https://docs.unity3d.com/Manual/SL-Stencil.html
			Stencil
			{
				Ref [_Ref]
				Comp [_Comp]
				Pass [_Pass]
				//ZFail [_Fail]
			}
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			LOD 200
			Pass
			{
				CGPROGRAM
				#pragma fragment frag
				#pragma vertex vert
				#include "UnityCG.cginc"
				#include "Lighting.cginc"

				struct appdata
				{
					float4 vertex:POSITION;
					float2 texcoord:TEXCOORD;
					float3 normal:NORMAL;
				};
				struct v2f
				{
					float4 pos:POSITION;
					float2 uv:TEXCOORD;
					float4 worldPos:TEXCOORD1;
					float3 wNormal:NORMAL;
					float3 wView:TEXCOORD2;
				};
				float4 _Color;
				float4 _SpecularColor;
				sampler2D _MainTex;
				float _Glossiness;
				v2f vert(appdata i)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(i.vertex);
					o.uv = i.texcoord;
					o.worldPos = mul(unity_ObjectToWorld, i.vertex);
					o.wNormal = UnityObjectToWorldNormal(i.normal);
					o.wView = normalize(UnityWorldSpaceViewDir(o.worldPos));
					return o;
				}

				float4 blinPhong(v2f i)
				{
					float3 lightColor = _LightColor0.rgb;
					float4 color = tex2D(_MainTex, i.uv)*_Color;
					color.rgb *= lightColor;
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float3 h = normalize(i.wView + lightDir);
					float rv = saturate(dot(i.wNormal, h));
					float specular = pow(rv, _Glossiness);
					float diffuse = saturate(dot(i.wNormal, lightDir));
					color.rgb = diffuse * color.rgb + (specular * _SpecularColor);
					return color;
					//return (specular * _SpecularColor);
				}

				float4 frag(v2f i) :SV_TARGET
				{
					return blinPhong(i);
				}
				ENDCG
			}
		}
			//FallBack "Diffuse"
}
