// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/MonsterShader"
{
	Properties
	{
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_SmoothnessIntensity("Smoothness Intensity", Float) = 0
		_albedo("albedo", 2D) = "white" {}
		_Texture1("Texture 0", 2D) = "bump" {}
		_metallic("metallic", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _KEYWORD0_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture1;
		uniform float4 _Texture1_ST;
		uniform sampler2D _albedo;
		uniform float4 _albedo_ST;
		uniform sampler2D _metallic;
		uniform float4 _metallic_ST;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float _SmoothnessIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float3 tex2DNode1 = UnpackNormal( tex2D( _Texture1, uv_Texture1 ) );
			#ifdef _KEYWORD0_ON
				float3 staticSwitch10 = tex2DNode1;
			#else
				float3 staticSwitch10 = ( tex2DNode1 * float3(0,-1,0) );
			#endif
			o.Normal = staticSwitch10;
			float2 uv_albedo = i.uv_texcoord * _albedo_ST.xy + _albedo_ST.zw;
			o.Albedo = tex2D( _albedo, uv_albedo ).rgb;
			float2 uv_metallic = i.uv_texcoord * _metallic_ST.xy + _metallic_ST.zw;
			o.Metallic = tex2D( _metallic, uv_metallic ).r;
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			o.Smoothness = ( ( 1.0 - tex2D( _Texture0, uv_Texture0 ) ) * _SmoothnessIntensity ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
1920;0;1920;1011;1570.769;625.9298;1.420217;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;18;-704,-160;Inherit;True;Property;_Texture1;Texture 0;3;0;Create;True;0;0;0;False;0;False;80b4746327cab424caa838fc796c09f5;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;20;-904.0791,326.4121;Inherit;True;Property;_Texture0;Texture 0;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-561,305.5;Inherit;True;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;-1;2aff43e50a7a12b4d82002f6e8a89aea;2aff43e50a7a12b4d82002f6e8a89aea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;9;374.2885,126.5443;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,-1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-278.4274,-87.62017;Inherit;True;Property;_Normal;Normal;0;0;Create;True;0;0;0;False;0;False;-1;80b4746327cab424caa838fc796c09f5;2aff43e50a7a12b4d82002f6e8a89aea;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;22,381.5;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;99.94977,515.3503;Inherit;False;Property;_SmoothnessIntensity;Smoothness Intensity;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;556.2885,-41.45576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-154.4141,-284.8912;Inherit;True;Property;_albedo;albedo;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;19;-835,82;Inherit;True;Property;_metallic;metallic;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;2;-547,100.5;Inherit;True;Property;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;-1;74885fb651b580642a08819b1efe16c1;74885fb651b580642a08819b1efe16c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;251.9498,422.3503;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;158,-295.5;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;0;False;0;False;-1;458d1e0330be1d34ebb4bf79f3794492;458d1e0330be1d34ebb4bf79f3794492;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;10;814.2885,39.54424;Inherit;False;Property;_Keyword0;Keyword 0;0;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1172.828,23.6735;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/MonsterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;20;0
WireConnection;1;0;18;0
WireConnection;7;0;3;0
WireConnection;8;0;1;0
WireConnection;8;1;9;0
WireConnection;2;0;19;0
WireConnection;15;0;7;0
WireConnection;15;1;16;0
WireConnection;6;0;17;0
WireConnection;10;1;8;0
WireConnection;10;0;1;0
WireConnection;0;0;6;0
WireConnection;0;1;10;0
WireConnection;0;3;2;0
WireConnection;0;4;15;0
ASEEND*/
//CHKSM=BB0E493391AEF1EF4B0ECC9E1A50E4B0CD32DFE8