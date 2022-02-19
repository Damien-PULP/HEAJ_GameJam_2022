// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/BasicORMShader"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "white" {}
		[NoScaleOffset]_ORM("ORM", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Float) = 0.5
		_RoughessIntensity("RoughessIntensity", Float) = 1
		[Toggle]_InverseYNormal("Inverse Y Normal", Float) = 0
		_ColorAlbedo("ColorAlbedo", Color) = (1,1,1,0)
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _InverseYNormal;
		uniform sampler2D _Normal;
		uniform float _NormalIntensity;
		uniform float4 _ColorAlbedo;
		uniform sampler2D _Albedo;
		uniform sampler2D _ORM;
		uniform float _RoughessIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal3 = i.uv_texcoord;
			float3 tex2DNode3 = UnpackScaleNormal( tex2D( _Normal, uv_Normal3 ), _NormalIntensity );
			o.Normal = (( _InverseYNormal )?( ( tex2DNode3 * float3(1,-1,1) ) ):( tex2DNode3 ));
			float2 uv_Albedo2 = i.uv_texcoord;
			o.Albedo = ( _ColorAlbedo * tex2D( _Albedo, uv_Albedo2 ).r ).rgb;
			float2 uv_ORM5 = i.uv_texcoord;
			float4 tex2DNode5 = tex2D( _ORM, uv_ORM5 );
			o.Metallic = tex2DNode5.b;
			o.Smoothness = ( 1.0 - ( _RoughessIntensity * tex2DNode5.g ) );
			o.Occlusion = tex2DNode5.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
484;73;1208;709;731.7573;302.6739;1.020425;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;6;-949.5,762.5;Inherit;True;Property;_ORM;ORM;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;4;-903.5,269.5;Inherit;True;Property;_Normal;Normal;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;7;-860,472.5;Inherit;False;Property;_NormalIntensity;NormalIntensity;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-658.5,770.5;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-578,649.5;Inherit;False;Property;_RoughessIntensity;RoughessIntensity;4;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-646.5,266.5;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;11;-506.9557,472.6747;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;1;-904,49.5;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-237,706.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-313.2384,385.9343;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-644,49.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-553.183,-200.6313;Inherit;False;Property;_ColorAlbedo;ColorAlbedo;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;10;-19,598.5;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;13;-159.2384,263.9343;Inherit;False;Property;_InverseYNormal;Inverse Y Normal;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-262.3618,-35.32227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;243,75;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/BasicORMShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;6;0
WireConnection;3;0;4;0
WireConnection;3;5;7;0
WireConnection;9;0;8;0
WireConnection;9;1;5;2
WireConnection;14;0;3;0
WireConnection;14;1;11;0
WireConnection;2;0;1;0
WireConnection;10;0;9;0
WireConnection;13;0;3;0
WireConnection;13;1;14;0
WireConnection;15;0;16;0
WireConnection;15;1;2;1
WireConnection;0;0;15;0
WireConnection;0;1;13;0
WireConnection;0;3;5;3
WireConnection;0;4;10;0
WireConnection;0;5;5;1
ASEEND*/
//CHKSM=1DC7FFF021EF1E80B826D4D65E3F0693CD7964C5