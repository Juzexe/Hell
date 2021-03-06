#include "hellpch.h"
#include "Entity.h"
#include "Helpers/Util.h"
#include "Helpers/AssetManager.h"
#include "Core/LevelEditor.h"

namespace HellEngine
{
	Entity::Entity()
	{
	}

	Entity::Entity(char* tag)
	{
		m_tag = tag;
	}

	Entity::Entity(const Entity& cpy)
	{
		m_tag = cpy.m_tag;
		m_modelID = cpy.m_modelID;
		m_materialID = cpy.m_materialID;
		m_triangleMesh = cpy.m_triangleMesh;
		m_triangleMeshShape = cpy.m_triangleMeshShape;
		m_collisionObject = cpy.m_collisionObject;
		m_transform = cpy.m_transform;

		EntityData* entityData = (EntityData*)m_collisionObject->getUserPointer();
		entityData->ptr = this;
	}

	Entity& Entity::operator = (const Entity& input) {
		new (this) Entity(input);
		return *this;
	}

	Entity::Entity(int modelID)
	{
		m_modelID = modelID;
	}

	void Entity::Update(float deltaTime)
	{

	}

	void Entity::DrawEntity(Shader* shader)
	{
		LevelEditor::SetHighlightColorIfSelected(shader, this);
		AssetManager::BindMaterial_0(m_materialID);
		AssetManager::models[m_modelID].Draw(shader, m_transform.to_mat4());
		shader->setVec3("ColorAdd", glm::vec3(0, 0, 0));
	}

	void Entity::Draw(Shader* shader, glm::mat4 modelMatrix)
	{
		//if (m_modelID != -1)
		//	AssetManager::models[m_modelID].CalculateAnimation(m_currentAnimationName, m_currentAnimationTime);
		
		AssetManager::DrawModel(m_modelID, shader, modelMatrix);
	}

	void Entity::SetModelID(int modelID)
	{
		m_modelID = modelID;
		UpdateCollisionObject();
	}
	
	int Entity::GetModelID()
	{
		return m_modelID;
	}

	void Entity::Draw(Shader* shader)
	{
		//if (m_modelID != -1)
		//	AssetManager::models[m_modelID].CalculateAnimation(m_currentAnimationName, m_currentAnimationTime);
		
		AssetManager::DrawModel(m_modelID, shader, m_transform.to_mat4());
	}

	void Entity::UpdateCollisionObject()
	{
		static bool hasBeenCreatedBefore = false;
		if (hasBeenCreatedBefore) {
			Physics::s_dynamicsWorld->removeCollisionObject(m_collisionObject);
			delete m_triangleMesh;
			delete m_triangleMeshShape;
			delete m_collisionObject;
			hasBeenCreatedBefore = true;
		}

		m_triangleMesh = new btTriangleMesh();

		int indexCount = AssetManager::models[m_modelID].m_meshes[0]->indices.size();


		for (int i = 0; i < indexCount; i += 3)
		{
			std::vector<Vertex>* vertices = &AssetManager::models[m_modelID].m_meshes[0]->vertices;
			std::vector<unsigned int>* indices = &AssetManager::models[m_modelID].m_meshes[0]->indices;

			glm::vec3 scale = m_transform.scale;
			btVector3 vertA = Util::glmVec3_to_btVec3(vertices->at(indices->at(i)).Position);
			btVector3 vertB = Util::glmVec3_to_btVec3(vertices->at(indices->at(i + 1)).Position);
			btVector3 vertC = Util::glmVec3_to_btVec3(vertices->at(indices->at(i + 2)).Position);
			m_triangleMesh->addTriangle(vertA, vertB, vertC);
		}

		m_triangleMeshShape = new btBvhTriangleMeshShape(m_triangleMesh, true, true);

		btTransform meshTransform;
		meshTransform.setIdentity();
		meshTransform.setOrigin(Util::glmVec3_to_btVec3(m_transform.position));
		meshTransform.setRotation(Util::glmVec3_to_btQuat(m_transform.rotation));

		m_collisionObject = new btCollisionObject();
		m_collisionObject->setCollisionShape(m_triangleMeshShape);
		m_collisionObject->setWorldTransform(meshTransform);
		m_collisionObject->setFriction(0.5);
		m_collisionObject->setCustomDebugColor(btVector3(1, 0, 0));

		EntityData* entityData = new EntityData();
		entityData->type = PhysicsObjectType::MISC_MESH;
		entityData->ptr = this;

		m_collisionObject->setUserPointer(entityData);
		m_collisionObject->getCollisionShape()->setLocalScaling(Util::glmVec3_to_btVec3(m_transform.scale));

		int group = CollisionGroups::HOUSE;
		int mask = CollisionGroups::ENTITY | CollisionGroups::ENEMY;

		Physics::s_dynamicsWorld->addCollisionObject(m_collisionObject, group, mask);

		m_collisionObject->setCollisionFlags(m_collisionObject->getCollisionFlags() | btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK);
	}	
	
	void Entity::RemoveCollisionObject()
	{
		Physics::s_dynamicsWorld->removeCollisionObject(m_collisionObject);
	}
}