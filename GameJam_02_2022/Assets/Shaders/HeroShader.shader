// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/HeroShader"
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
		[Toggle]_InverseYNormal("Inverse Y Normal", Float) = 0
		_PercentEmission("PercentEmission", Range( 0 , 1)) = 1
		_NormalIntensity("NormalIntensity", Float) = 0.5
		_RoughnessIntensity("RoughnessIntensity", Range( 0 , 2)) = 1
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
		uniform float _NormalIntensity;
		uniform sampler2D _Albedo;
		uniform float4 _MinColorEmission;
		uniform float4 _MaxColorEmission;
		uniform sampler2D _Emissive;
		uniform float _MinIntensityFlash;
		uniform float _MaxIntensityFlash;
		uniform float _SpeedFlashEmission;
		uniform float _PercentEmission;
		uniform sampler2D _ORM;
		uniform float _RoughnessIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal15 = i.uv_texcoord;
			float3 tex2DNode15 = UnpackScaleNormal( tex2D( _Normal, uv_Normal15 ), _NormalIntensity );
			float3 Normal29 = (( _InverseYNormal )?( ( tex2DNode15 * float3(1,-1,1) ) ):( tex2DNode15 ));
			o.Normal = Normal29;
			float2 uv_Albedo27 = i.uv_texcoord;
			float4 Albedo31 = tex2D( _Albedo, uv_Albedo27 );
			o.Albedo = Albedo31.rgb;
			float2 uv_Emissive12 = i.uv_texcoord;
			float4 tex2DNode12 = tex2D( _Emissive, uv_Emissive12 );
			float mulTime2 = _Time.y * _SpeedFlashEmission;
			float lerpResult8 = lerp( _MinIntensityFlash , _MaxIntensityFlash , ( ( sin( mulTime2 ) + 1.0 ) * 0.5 ));
			float FlashEmission10 = lerpResult8;
			float4 lerpResult24 = lerp( _MinColorEmission , _MaxColorEmission , saturate( ( tex2DNode12 * FlashEmission10 ) ));
			float4 Emission33 = ( lerpResult24 * tex2DNode12 * _PercentEmission );
			o.Emission = Emission33.rgb;
			float2 uv_ORM23 = i.uv_texcoord;
			float4 tex2DNode23 = tex2D( _ORM, uv_ORM23 );
			float Metalness32 = tex2DNode23.b;
			o.Metallic = Metalness32;
			float Roughness28 = tex2DNode23.g;
			o.Smoothness = ( 1.0 - ( Roughness28 * _RoughnessIntensity ) );
			float AmbientOcclusion30 = tex2DNode23.r;
			o.Occlusion = AmbientOcclusion30;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
484;73;1208;1007;932.2813;183.5811;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-2049.705,272.7505;Inherit;False;Property;_SpeedFlashEmission;SpeedFlashEmission;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1796.205,270.7505;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;-1548.329,264.571;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-1390.329,282.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1305.558,155.1381;Inherit;False;Property;_MaxIntensityFlash;MaxIntensityFlash;8;0;Create;True;0;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1189.329,272.571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1313.593,89.85556;Inherit;False;Property;_MinIntensityFlash;MinIntensityFlash;7;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-974.123,128.0211;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-2141.744,570.9991;Inherit;True;Property;_Emissive;Emissive;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-734.7107,105.9428;Inherit;False;FlashEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-1792.169,761.0071;Inherit;False;10;FlashEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1887.745,569.9991;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1541.601,719.3865;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1900.727,-236.4677;Inherit;True;Property;_Normal;Normal;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;42;-1557.83,-111.6755;Inherit;False;Property;_NormalIntensity;NormalIntensity;11;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-1579.029,1214.235;Inherit;True;Property;_ORM;ORM;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;15;-1248.685,-174.5587;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;19;-1313.169,922.007;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-1176.967,391.8633;Inherit;False;Property;_MinColorEmission;MinColorEmission;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-1173.169,566.0071;Inherit;False;Property;_MaxColorEmission;MaxColorEmission;5;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;16;-928.2968,-86.49924;Inherit;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;1,-1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;23;-1325.029,1213.235;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1032.969,956.5998;Inherit;False;Property;_PercentEmission;PercentEmission;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-677.2968,-74.49924;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-1493.644,-371.9395;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-932.0278,1189.735;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-878.0486,676.3628;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-438.8129,269.397;Inherit;False;28;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-670.6242,804.931;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-466.2813,363.4189;Inherit;False;Property;_RoughnessIntensity;RoughnessIntensity;12;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;25;-537.2968,-216.4992;Inherit;False;Property;_InverseYNormal;Inverse Y Normal;9;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;27;-1239.644,-372.9395;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-931.6723,1100.916;Inherit;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-184.2813,251.4189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-928.0278,1276.735;Inherit;False;Metalness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-753.285,-374.1586;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-262.5453,-222.3156;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-466.0713,797.5739;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;40;5.187134,215.397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-84.81287,-119.603;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-80.81287,22.39703;Inherit;False;33;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-79.81287,120.397;Inherit;False;32;Metalness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-86.81287,-42.60297;Inherit;False;29;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-90.81287,421.397;Inherit;False;30;AmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;403.9317,-81.16662;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/HeroShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;7;0;4;0
WireConnection;8;0;5;0
WireConnection;8;1;6;0
WireConnection;8;2;7;0
WireConnection;10;0;8;0
WireConnection;12;0;9;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;15;0;13;0
WireConnection;15;5;42;0
WireConnection;19;0;14;0
WireConnection;23;0;17;0
WireConnection;21;0;15;0
WireConnection;21;1;16;0
WireConnection;28;0;23;2
WireConnection;24;0;20;0
WireConnection;24;1;18;0
WireConnection;24;2;19;0
WireConnection;26;0;24;0
WireConnection;26;1;12;0
WireConnection;26;2;34;0
WireConnection;25;0;15;0
WireConnection;25;1;21;0
WireConnection;27;0;22;0
WireConnection;30;0;23;1
WireConnection;43;0;39;0
WireConnection;43;1;44;0
WireConnection;32;0;23;3
WireConnection;31;0;27;0
WireConnection;29;0;25;0
WireConnection;33;0;26;0
WireConnection;40;0;43;0
WireConnection;0;0;35;0
WireConnection;0;1;36;0
WireConnection;0;2;37;0
WireConnection;0;3;38;0
WireConnection;0;4;40;0
WireConnection;0;5;41;0
ASEEND*/
//CHKSM=383E46879DE3E653B21CEBA72E162F838494EFF7