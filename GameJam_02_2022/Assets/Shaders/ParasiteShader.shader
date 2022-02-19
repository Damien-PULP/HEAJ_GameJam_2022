// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/ParasiteShader"
{
	Properties
	{
		_TillingTextureParasite("TillingTextureParasite", Vector) = (1,1,0,0)
		[NoScaleOffset]_TextureParasite("TextureParasite", 2D) = "white" {}
		_SideEffect("SideEffect", Float) = 0
		_CenterPosition("CenterPosition", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0
		_ParasiteColor("ParasiteColor", Color) = (1,0,0,0)
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Tilling("Tilling", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Albedo;
		uniform float2 _Tilling;
		uniform float3 _CenterPosition;
		uniform float _Radius;
		uniform float _SideEffect;
		uniform sampler2D _TextureParasite;
		uniform float2 _TillingTextureParasite;
		uniform float4 _ParasiteColor;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord168 = i.uv_texcoord * _Tilling;
			float2 UVs167 = uv_TexCoord168;
			float4 Albedo189 = tex2D( _Albedo, UVs167 );
			float3 ase_worldPos = i.worldPos;
			float temp_output_5_0_g2 = _Radius;
			float temp_output_9_0_g2 = ( ( distance( ase_worldPos , _CenterPosition ) - temp_output_5_0_g2 ) / ( temp_output_5_0_g2 - _SideEffect ) );
			float temp_output_133_0 = saturate( temp_output_9_0_g2 );
			float MaxEffectPosition134 = temp_output_133_0;
			float2 uv_TexCoord136 = i.uv_texcoord * _TillingTextureParasite;
			float4 TexturePattern151 = tex2D( _TextureParasite, uv_TexCoord136 );
			float4 AlbedoParasite172 = ( MaxEffectPosition134 * TexturePattern151 * _ParasiteColor );
			float Alpha150 = MaxEffectPosition134;
			float4 lerpResult154 = lerp( Albedo189 , AlbedoParasite172 , Alpha150);
			float4 AlbedoFinal161 = lerpResult154;
			o.Albedo = AlbedoFinal161.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
474;73;1119;748;3583.22;1238.726;4.407986;True;False
Node;AmplifyShaderEditor.CommentaryNode;159;-1792.303,1938.875;Inherit;False;1255.759;424.0004;Parasite Texture;5;130;136;138;151;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;158;-1768.452,2397.999;Inherit;False;1278.216;476.479;Alpha Parasite Circle;8;148;135;133;141;143;144;142;134;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;188;-1388.642,-162.9372;Inherit;False;752.8691;220.9164;UVs;3;169;168;167;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;141;-1712.709,2447.999;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;148;-1718.452,2611.524;Inherit;False;Property;_CenterPosition;CenterPosition;4;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;130;-1770.303,2188.875;Inherit;False;Property;_TillingTextureParasite;TillingTextureParasite;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;169;-1338.642,-106.0208;Inherit;False;Property;_Tilling;Tilling;11;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;138;-1563.304,1988.875;Inherit;True;Property;_TextureParasite;TextureParasite;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DistanceOpNode;135;-1302.451,2531.524;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-1324.679,2675.515;Inherit;False;Property;_Radius;Radius;5;0;Create;True;0;0;0;False;0;False;0;51.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1331.325,2758.478;Inherit;False;Property;_SideEffect;SideEffect;3;0;Create;True;0;0;0;False;0;False;0;37.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-1547.304,2180.875;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;168;-1148.43,-112.9372;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;-1226.693,2091.748;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;133;-1110.452,2579.524;Inherit;False;Invers_Lerp;-1;;2;65c518da2a8456d4585ebf1c79f44daf;1,11,1;3;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;191;-1867.168,143.6146;Inherit;False;1201.618;1694.07;PBR;21;174;175;176;178;179;177;182;180;181;163;170;164;189;166;186;165;171;185;184;187;183;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-859.7728,-107.4229;Inherit;False;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;160;-1792.108,2923.953;Inherit;False;1347.173;833.0323;Blend;11;161;154;173;190;157;150;172;139;131;132;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-732.235,2525.13;Inherit;False;MaxEffectPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-761.5433,2094.047;Inherit;False;TexturePattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;152;-1198.245,3188.766;Inherit;False;Property;_ParasiteColor;ParasiteColor;6;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;170;-1760.066,382.7256;Inherit;False;167;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-1199.126,2979.953;Inherit;False;134;MaxEffectPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;163;-1817.168,193.6146;Inherit;True;Property;_Albedo;Albedo;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1188.523,3114.217;Inherit;False;151;TexturePattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;164;-1535.536,299.2703;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-937.6563,3057.146;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-1202.229,303.3654;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-712.8823,3068.083;Inherit;False;AlbedoParasite;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;150;-715.1259,2973.953;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-1217.115,3654.372;Inherit;False;150;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-1220.371,3471.985;Inherit;False;189;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-1235.208,3565.028;Inherit;False;172;AlbedoParasite;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;154;-967.0671,3542.621;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-706.001,3538.898;Inherit;False;AlbedoFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;180;-1810.889,1185.867;Inherit;True;Property;_Emission;Emission;10;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-889.5504,1168.657;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;184;-1454.975,830.7429;Inherit;False;Property;_MinColorEmission;MinColorEmission;12;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;171;-1786.588,680.9299;Inherit;False;167;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;183;-1185.921,1153.735;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;185;-1456.275,1002.343;Inherit;False;Property;_MaxColorEmission;MaxColorEmission;13;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;165;-1812.713,492.1961;Inherit;True;Property;_Normal;Normal;8;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMaxOpNode;142;-737.942,2623.188;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;-1543.435,1184.723;Inherit;True;Property;_TextureSample4;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-1086.329,1721.685;Inherit;False;Metalness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;182;-1760.832,1395.873;Inherit;False;167;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-1104.329,1534.684;Inherit;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;-1089.329,1622.684;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;-1519.474,1542.466;Inherit;True;Property;_TextureSample3;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;162;379.6663,307.7081;Inherit;False;161;AlbedoFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-1751.308,1704.701;Inherit;False;167;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-1201.349,607.0857;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;175;-1806.426,1512.41;Inherit;True;Property;_ORM;ORM;9;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;166;-1570.964,580.752;Inherit;True;Property;_TextureSample2;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;645.0566,316.5013;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/ParasiteShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;Background;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;135;0;141;0
WireConnection;135;1;148;0
WireConnection;136;0;130;0
WireConnection;168;0;169;0
WireConnection;137;0;138;0
WireConnection;137;1;136;0
WireConnection;133;4;135;0
WireConnection;133;5;143;0
WireConnection;133;6;144;0
WireConnection;167;0;168;0
WireConnection;134;0;133;0
WireConnection;151;0;137;0
WireConnection;164;0;163;0
WireConnection;164;1;170;0
WireConnection;139;0;132;0
WireConnection;139;1;131;0
WireConnection;139;2;152;0
WireConnection;189;0;164;0
WireConnection;172;0;139;0
WireConnection;150;0;132;0
WireConnection;154;0;190;0
WireConnection;154;1;173;0
WireConnection;154;2;157;0
WireConnection;161;0;154;0
WireConnection;187;0;183;0
WireConnection;183;0;184;0
WireConnection;183;1;185;0
WireConnection;183;2;181;0
WireConnection;142;0;133;0
WireConnection;181;0;180;0
WireConnection;181;1;182;0
WireConnection;179;0;176;3
WireConnection;177;0;176;1
WireConnection;178;0;176;2
WireConnection;176;0;175;0
WireConnection;176;1;174;0
WireConnection;186;0;166;0
WireConnection;166;0;165;0
WireConnection;166;1;171;0
WireConnection;0;0;162;0
ASEEND*/
//CHKSM=FD73BB5DC84DBDB409D2EA3D8A29C32D30A25D50