#pragma once
#include "Renderer/Texture.h"
#include "Renderer/Material.h"
#include "Renderer/Model.h"
#include "Renderer/AssimpModel.h"
#include <vector>
#include <future>

namespace HellEngine
{
	class AssetManager
	{
	public: // static containers
		static std::vector<Texture> textures;
		static std::vector<Material> materials;
		static std::vector<Model> models;

		static std::mutex s_TexturesMutex;
		static std::mutex s_ModelsMutex;
		static std::mutex s_AnimationsMutex;
		static std::vector<std::future<void>> AssetManager::m_Futures;

	public: // functions
		static void LoadAllTextures();
		static void LoadHardcoded();
		static void AddMaterial(std::string name);
		static void LoadNextReadyAssetToGL();
		static void AssignHardcodedModelMaterials();


		static void SetModelMaterialIDByModelID(unsigned int modelID, unsigned int materialID);
		static void SetModelMaterialIDByModelIDMeshName(unsigned int modelID, std::string meshName, unsigned int materialID);
		static unsigned int GetTexIDByName(std::string textureName);
		static int GetModelIDByName(std::string textureName);
		static Model* GetModelByID(int modelID);
		static Model* GetModelByName(std::string modelName);
		static void DrawModel(int modelID, Shader* shader, glm::mat4 modelMatrix);
		static void DrawMesh(int modelID, int meshIndex, Shader* shader, glm::mat4 modelMatrix);
		static unsigned int GetAlbTexID(unsigned int materialID);
		static unsigned int GetNrmTexID(unsigned int materialID);
		static unsigned int GetRmaTexID(unsigned int materialID);
		static unsigned int GetRmeTexID(unsigned int materialID);
		static unsigned int GetMaterialIDByName(std::string name);
		static void BindMaterial(unsigned int materialID);
		static std::string GetMaterialNameByID(unsigned int materialID);

		static AssimpModel LoadFromFile(std::string const& path);		
		static void processNode(aiNode* node, const aiScene* scene, MeshList* meshList);
		static Mesh processMesh(aiMesh* mesh, const aiScene* scene);

		static void AssetManager::MultiThreadedReadTextureFromDisk(Texture* texture);
		//static void AssetManager::MultiThreadedReadModelFromDisk(Model* model);
		//static void AssetManager::MultiThreadedLoadAnimation(Model* model, const char* filepath, const char* name);

	public: // fields
		static unsigned int currentlyBoundMaterialID;

	public:
		// hacky hardcodes
		static unsigned int s_ModelID_Sphere;
		static unsigned int s_ModelID_FloorTrim;
		static unsigned int s_ModelID_CeilingTrim;
		static unsigned int s_ModelID_DoorFrame;
		static unsigned int s_ModelID_Door;

		static unsigned int s_MaterialID_Trims;
		static unsigned int s_MaterialID_FloorBoards;
		static unsigned int s_MaterialID_PlasterCeiling;
		static unsigned int s_MaterialID_WallPaper;
	};
}