// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Test Ground Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float3 OriginPostionVirus;
		uniform float RadiusVirus;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color122 = IsGammaSpace() ? float4(0,0.2274976,1,0) : float4(0,0.04232816,1,0);
			float4 color123 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float3 appendResult128 = (float3(( OriginPostionVirus.x + RadiusVirus ) , ( OriginPostionVirus.y + RadiusVirus ) , ( OriginPostionVirus.z + RadiusVirus )));
			float4 lerpResult119 = lerp( color122 , color123 , length( appendResult128 ));
			o.Albedo = lerpResult119.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18917
-72;210;1920;890;2275.453;963.6796;1.6;True;False
Node;AmplifyShaderEditor.Vector3Node;120;-1634.498,-246.9985;Inherit;False;Global;OriginPostionVirus;OriginPostionVirus;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;121;-1642.498,-82.99846;Inherit;False;Global;RadiusVirus;RadiusVirus;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1357.495,-235.1997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-1363.495,-125.1997;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;-1360.495,-4.199688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-1149.495,-181.1997;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;129;-902.4946,-143.1997;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;123;-967.8978,-379.9985;Inherit;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;122;-975.8979,-579.2984;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0.2274976,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;119;-515.4978,-233.9984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;312,-290.6;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Test Ground Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;125;0;120;1
WireConnection;125;1;121;0
WireConnection;126;0;120;2
WireConnection;126;1;121;0
WireConnection;127;0;120;3
WireConnection;127;1;121;0
WireConnection;128;0;125;0
WireConnection;128;1;126;0
WireConnection;128;2;127;0
WireConnection;129;0;128;0
WireConnection;119;0;122;0
WireConnection;119;1;123;0
WireConnection;119;2;129;0
WireConnection;0;0;119;0
ASEEND*/
//CHKSM=D5EE8F0D058CC7FAE9A9A76E0C43CBBC74B539F6