// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/MonsterShader"
{
	Properties
	{
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_albedo("albedo", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "bump" {}
		_Texture2("Texture 2", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _KEYWORD0_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _albedo;
		uniform float4 _albedo_ST;
		uniform sampler2D _Texture2;
		uniform float4 _Texture2_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float3 tex2DNode1 = UnpackScaleNormal( tex2D( _Texture0, uv_Texture0 ), _NormalIntensity );
			#ifdef _KEYWORD0_ON
				float3 staticSwitch10 = tex2DNode1;
			#else
				float3 staticSwitch10 = ( tex2DNode1 * float3(1,-1,1) );
			#endif
			o.Normal = staticSwitch10;
			float2 uv_albedo = i.uv_texcoord * _albedo_ST.xy + _albedo_ST.zw;
			o.Albedo = tex2D( _albedo, uv_albedo ).rgb;
			float2 uv_Texture2 = i.uv_texcoord * _Texture2_ST.xy + _Texture2_ST.zw;
			float4 tex2DNode22 = tex2D( _Texture2, uv_Texture2 );
			o.Metallic = tex2DNode22.b;
			o.Smoothness = ( 1.0 - tex2DNode22.g );
			o.Occlusion = tex2DNode22.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
0;0;1920;1011;787.8592;528.6127;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;18;-321.8809,-323.1537;Inherit;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;0;False;0;False;80b4746327cab424caa838fc796c09f5;80b4746327cab424caa838fc796c09f5;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;30;-301.4117,-46.40304;Inherit;False;Property;_NormalIntensity;Normal Intensity;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;21;146.845,179.542;Inherit;True;Property;_Texture2;Texture 2;3;0;Create;True;0;0;0;False;0;False;None;ecfea6dcf38f9384a8a99b62f0c0c44b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;9;266.3885,-258.9557;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;27.77254,-169.9202;Inherit;True;Property;_Normal;Normal;0;0;Create;True;0;0;0;False;0;False;-1;80b4746327cab424caa838fc796c09f5;2aff43e50a7a12b4d82002f6e8a89aea;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;471.1343,201.239;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;17;540.5858,-380.7914;Inherit;True;Property;_albedo;albedo;1;0;Create;True;0;0;0;False;0;False;None;458d1e0330be1d34ebb4bf79f3794492;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;545.2885,-100.4558;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;23;1073.765,193.9214;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;10;814.2885,39.54424;Inherit;False;Property;_Keyword0;Keyword 0;0;0;Create;True;0;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;6;847.3999,-376.9001;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;0;False;0;False;-1;458d1e0330be1d34ebb4bf79f3794492;458d1e0330be1d34ebb4bf79f3794492;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1388.328,-96.12651;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/MonsterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;18;0
WireConnection;1;5;30;0
WireConnection;22;0;21;0
WireConnection;8;0;1;0
WireConnection;8;1;9;0
WireConnection;23;0;22;2
WireConnection;10;1;8;0
WireConnection;10;0;1;0
WireConnection;6;0;17;0
WireConnection;0;0;6;0
WireConnection;0;1;10;0
WireConnection;0;3;22;3
WireConnection;0;4;23;0
WireConnection;0;5;22;1
ASEEND*/
//CHKSM=79DB354B7B6065954688F6C03C2E41768040B139