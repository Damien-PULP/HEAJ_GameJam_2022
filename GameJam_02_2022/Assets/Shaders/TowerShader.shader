// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/TowerShader"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "white" {}
		[NoScaleOffset]_ORM("ORM", 2D) = "white" {}
		[NoScaleOffset]_Emissive("Emissive", 2D) = "white" {}
		[HDR]_MinColorEmission("MinColorEmission", Color) = (0,0,0,0)
		[HDR]_MaxColorEmission("MaxColorEmission", Color) = (0,0,0,0)
		_SpeedFlashEmission("SpeedFlashEmission", Float) = 1
		_MinIntensityFlash("MinIntensityFlash", Float) = 0.8
		_MaxIntensityFlash("MaxIntensityFlash", Float) = 1.2
		[Toggle]_InverseYNormal("Inverse Y Normal", Float) = 1
		_IntensityNormal("IntensityNormal", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _InverseYNormal;
		uniform sampler2D _Normal;
		uniform float _IntensityNormal;
		uniform sampler2D _Albedo;
		uniform float4 _MinColorEmission;
		uniform float4 _MaxColorEmission;
		uniform sampler2D _Emissive;
		uniform float _MinIntensityFlash;
		uniform float _MaxIntensityFlash;
		uniform float _SpeedFlashEmission;
		uniform sampler2D _ORM;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal3 = i.uv_texcoord;
			float3 tex2DNode3 = UnpackScaleNormal( tex2D( _Normal, uv_Normal3 ), _IntensityNormal );
			float3 Normal17 = (( _InverseYNormal )?( ( tex2DNode3 * float3(1,-1,1) ) ):( tex2DNode3 ));
			o.Normal = Normal17;
			float2 uv_Albedo2 = i.uv_texcoord;
			float4 Albedo10 = tex2D( _Albedo, uv_Albedo2 );
			o.Albedo = Albedo10.rgb;
			float2 uv_Emissive12 = i.uv_texcoord;
			float4 tex2DNode12 = tex2D( _Emissive, uv_Emissive12 );
			float mulTime18 = _Time.y * _SpeedFlashEmission;
			float lerpResult23 = lerp( _MinIntensityFlash , _MaxIntensityFlash , ( ( sin( mulTime18 ) + 1.0 ) * 0.5 ));
			float FlashEmission27 = lerpResult23;
			float4 lerpResult28 = lerp( _MinColorEmission , _MaxColorEmission , saturate( ( tex2DNode12 * FlashEmission27 ) ));
			float4 Emission16 = ( lerpResult28 * tex2DNode12 );
			o.Emission = Emission16.rgb;
			float2 uv_ORM6 = i.uv_texcoord;
			float4 tex2DNode6 = tex2D( _ORM, uv_ORM6 );
			float Metalness9 = tex2DNode6.b;
			o.Metallic = Metalness9;
			float Roughness8 = tex2DNode6.g;
			o.Smoothness = ( 1.0 - Roughness8 );
			float AmbientOcclusion7 = tex2DNode6.r;
			o.Occlusion = AmbientOcclusion7;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
1913;12;1920;999;2014.023;-387.6541;1.071797;True;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-2077.432,510.2985;Inherit;False;Property;_SpeedFlashEmission;SpeedFlashEmission;6;0;Create;True;0;0;0;False;0;False;1;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;18;-1823.932,508.2985;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-1576.056,502.119;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1418.056,520.119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1217.056,510.119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1341.32,327.4036;Inherit;False;Property;_MinIntensityFlash;MinIntensityFlash;7;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1333.285,392.6861;Inherit;False;Property;_MaxIntensityFlash;MaxIntensityFlash;8;0;Create;True;0;0;0;False;0;False;1.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-1001.85,365.5691;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-762.4376,343.4908;Inherit;False;FlashEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-2169.471,808.5472;Inherit;True;Property;_Emissive;Emissive;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;d13e65ba4ad41c44ca087d882eedeb55;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;12;-1915.472,807.5472;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1819.896,998.5552;Inherit;False;27;FlashEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1516.328,810.9346;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1879.412,-26.01063;Inherit;True;Property;_Normal;Normal;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;23a95b226669897449bb697ce3e6a58a;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;43;-1785.142,224.4274;Inherit;False;Property;_IntensityNormal;IntensityNormal;10;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-1229.694,650.4113;Inherit;False;Property;_MinColorEmission;MinColorEmission;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,2.504478,5.278032,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;30;-1336.896,1039.555;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1276.412,62.98937;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;41;-947.0237,181.0488;Inherit;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1504.121,1326.697;Inherit;True;Property;_ORM;ORM;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;e16e44488e7ecd3459b7e468b6e33de2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;31;-1225.896,824.5552;Inherit;False;Property;_MaxColorEmission;MaxColorEmission;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,3.418236,3.688605,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1521.371,-134.3915;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;20f732f3f8033354a8626d33b2d29d6e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;28;-905.7755,913.9108;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-1250.121,1325.697;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-705.0237,163.0488;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-861.12,1342.197;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;39;-565.0237,21.04883;Inherit;False;Property;_InverseYNormal;Inverse Y Normal;9;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-640.5515,999.6787;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1267.371,-135.3915;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-871.7645,1240.378;Inherit;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-781.0119,-136.6106;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-217.3943,65.54521;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;732.3262,377.6512;Inherit;False;8;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-861.12,1421.197;Inherit;False;Metalness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-563.5983,874.7223;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;757.3258,485.8512;Inherit;False;7;AmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;922.126,325.6512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;757.0262,69.55122;Inherit;False;17;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;759.0734,150.2037;Inherit;False;16;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;754.426,-44.84875;Inherit;False;10;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;754.426,232.0513;Inherit;False;9;Metalness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1329.719,-49.35439;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/TowerShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;19;0
WireConnection;20;0;18;0
WireConnection;21;0;20;0
WireConnection;22;0;21;0
WireConnection;23;0;24;0
WireConnection;23;1;26;0
WireConnection;23;2;22;0
WireConnection;27;0;23;0
WireConnection;12;0;11;0
WireConnection;15;0;12;0
WireConnection;15;1;29;0
WireConnection;30;0;15;0
WireConnection;3;0;4;0
WireConnection;3;5;43;0
WireConnection;28;0;14;0
WireConnection;28;1;31;0
WireConnection;28;2;30;0
WireConnection;6;0;5;0
WireConnection;40;0;3;0
WireConnection;40;1;41;0
WireConnection;8;0;6;2
WireConnection;39;0;3;0
WireConnection;39;1;40;0
WireConnection;42;0;28;0
WireConnection;42;1;12;0
WireConnection;2;0;1;0
WireConnection;7;0;6;1
WireConnection;10;0;2;0
WireConnection;17;0;39;0
WireConnection;9;0;6;3
WireConnection;16;0;42;0
WireConnection;37;0;36;0
WireConnection;0;0;33;0
WireConnection;0;1;34;0
WireConnection;0;2;32;0
WireConnection;0;3;35;0
WireConnection;0;4;37;0
WireConnection;0;5;38;0
ASEEND*/
//CHKSM=13C5EC34B92B87A9554CEF92B16B7F7454116ECA