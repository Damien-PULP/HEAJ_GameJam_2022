using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class TextureImporterEditor : AssetPostprocessor
{
    void OnPreprocessTexture()
    {
        TextureImporter textureImporter = (TextureImporter)assetImporter;
        if (assetPath.ToLower().Contains("_normal") ||
            assetPath.Contains("_N"))
        {
            textureImporter.convertToNormalmap = true;
        }
        if (assetPath.ToLower().Contains("_mask") ||
            assetPath.ToLower().Contains("_m") ||
            assetPath.ToLower().Contains("_ao") ||
            assetPath.ToLower().Contains("_ambientocclusion") ||
            assetPath.ToLower().Contains("_r") ||
            assetPath.ToLower().Contains("_roughness") ||
            assetPath.ToLower().Contains("_m") ||
            assetPath.ToLower().Contains("_metalness") ||
            assetPath.ToLower().Contains("_e") ||
            assetPath.ToLower().Contains("_emission") ||
            assetPath.ToLower().Contains("_orm")) 
        {

            textureImporter.sRGBTexture = false;
        }
    }
}
