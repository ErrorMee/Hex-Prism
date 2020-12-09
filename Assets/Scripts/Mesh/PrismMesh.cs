using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]

public class PrismMesh : MonoBehaviour
{
	[SerializeField]
	[Range(3,32)]
	private int m_Edges = 3;
	public int EdgeNumber
	{
		get { return m_Edges; }
		set { m_Edges = Mathf.Clamp(value, 3, 32); UpdateMesh(); }
	}

	[SerializeField]
	[Range(0, 16)]
	private float m_Height = 1f;

	[SerializeField]
	[Range(0, 1)]
	private float m_Rise = 0.2f;

	private Vector3[] vertices;

	private Mesh mesh;

	private void Awake()
    {
		Generate();
	}

	private void OnValidate()
	{
		Generate();
	}

	private void Generate()
	{
		GetComponent<MeshFilter>().mesh = mesh = new Mesh();

		UpdateMesh();
	}

	private void UpdateMesh()
	{
		mesh.name = "Prism" + m_Edges;

		UpdateVertices();
		UpdateTriangles();
	}

	private void UpdateVertices()
	{
		vertices = new Vector3[m_Edges * 9 + 1];
		Vector3[] normals = new Vector3[vertices.Length];
		Vector2[] uvs = new Vector2[vertices.Length];

		float angleE = Mathf.PI * 2 / m_Edges;

		for (int e = 0; e < m_Edges; e++)
		{
			float angle = angleE * e;

			float sin = Mathf.Sin(angle);
			float cos = Mathf.Cos(angle);

			int index0 = (e + m_Edges * 0) * 2; int index1 = index0 + 1;
			int index2 = (e + m_Edges * 1) * 2; int index3 = index2 + 1;
			int index4 = (e + m_Edges * 2) * 2; int index5 = index4 + 1;
			int index6 = (e + m_Edges * 3) * 2; int index7 = index6 + 1;
			int index8 = e + m_Edges * 8;
			
			//vertices
			vertices[index0] = 
			vertices[index1] = new Vector3(cos * 0.5f, 0, sin * 0.5f);
			vertices[index2] = vertices[index3] =
			vertices[index4] = vertices[index5] = new Vector3(cos * 0.5f, m_Height, sin * 0.5f);
			vertices[index6] = vertices[index7] = vertices[index8] = 
				new Vector3(cos * 0.5f * (1 - m_Rise), m_Height + 0.5f * m_Rise, sin * 0.5f * (1 - m_Rise));

			//uvs
			if (e == 0)
			{
				uvs[index0] = new Vector2(1, 0);
				uvs[index2] = uvs[index4] = new Vector2(1, 1);
			}
			else
			{
				uvs[index0] = new Vector2(e / (float)m_Edges, 0);
				uvs[index2] = uvs[index4] = new Vector2(e / (float)m_Edges, 1);
			}

			uvs[index1] = new Vector2(e / (float)m_Edges, 0);
			uvs[index3] = new Vector2(e / (float)m_Edges, 1);

			uvs[index4] = uvs[index5] = new Vector2(cos, sin) * 0.5f + Vector2.one * 0.5f;
			uvs[index6] = uvs[index7] = uvs[index8] = uvs[index4] - new Vector2(cos, sin) * 0.5f * m_Rise;
		}

		for (int e = 0; e < m_Edges; e++)
		{
			int index0 = (e + m_Edges * 0) * 2; int index1 = index0 + 1;
			int index2 = (e + m_Edges * 1) * 2; int index3 = index2 + 1;
			int index4 = (e + m_Edges * 2) * 2; int index5 = index4 + 1;
			int index6 = (e + m_Edges * 3) * 2; int index7 = index6 + 1;
			int index8 = e + m_Edges * 8;
			//normals
			normals[index0] = normals[index2] = (vertices[index0] + vertices[index0 == 0 ? m_Edges * 2 - 1 : index0 - 1]) / 2;
			normals[index4] = normals[index6] = ((vertices[index4] + vertices[index4 == m_Edges * 2 ? m_Edges * 4 - 1 : index4 - 1]) / 2
				+ Vector3.up * (m_Height + m_Rise)) / 2 - Vector3.up * m_Height;
			normals[index1] = normals[index3] = (vertices[index1] + vertices[index1 == m_Edges * 2 - 1 ? 0 : index1 + 1]) / 2;
			normals[index5] = normals[index7] = ((vertices[index5] + vertices[index5 == m_Edges * 4 - 1 ? m_Edges * 2 : index5 + 1]) / 2
				+ Vector3.up * (m_Height + m_Rise)) / 2 - Vector3.up * m_Height;
			normals[index8] = Vector3.up;
		}

		vertices[vertices.Length - 1] = Vector3.up * (m_Height + 0.5f * m_Rise);
		normals[vertices.Length - 1] = Vector3.up;
		uvs[vertices.Length - 1] = Vector2.one * 0.5f;

		mesh.vertices = vertices;
		mesh.uv = uvs;
		mesh.normals = normals;
	}

	private void UpdateTriangles()
	{
		int[] trianglesBarrel = new int[m_Edges * 2 * 3];
		int[] trianglesCover = new int[m_Edges * 3 * 3];

		int index = 0;
		for (int ti = 0; ti < m_Edges; ti++)
		{
			int startIndex = ti * 2 + 1;
			trianglesBarrel[index++] = startIndex;//1
			trianglesBarrel[index++] = startIndex + m_Edges * 2;//2

			if (ti == m_Edges - 1)//3
			{
				trianglesBarrel[index++] = m_Edges * 2;
			}
			else
			{
				trianglesBarrel[index++] = startIndex + m_Edges * 2 + 1;
			}

			trianglesBarrel[index++] = startIndex;//4

			if (ti == m_Edges - 1)//5
			{
				trianglesBarrel[index++] = m_Edges * 2;
			}
			else
			{
				trianglesBarrel[index++] = startIndex + m_Edges * 2 + 1;
			}

			if (ti == m_Edges - 1)//6
			{
				trianglesBarrel[index++] = 0;
			}
			else
			{
				trianglesBarrel[index++] = startIndex + 1;
			}
		}

		for (int ti = 0; ti < trianglesBarrel.Length; ti++)
		{
			trianglesCover[ti] = trianglesBarrel[ti] + m_Edges * 4;
		}

		for (int ti = 0; ti < m_Edges; ti++)
		{
			trianglesCover[trianglesBarrel.Length + ti * 3 + 0] = m_Edges * 8 + ti;
			trianglesCover[trianglesBarrel.Length + ti * 3 + 1] = vertices.Length - 1;
			if (trianglesBarrel.Length + ti * 3 + 2 == trianglesCover.Length - 1)
			{
				trianglesCover[trianglesBarrel.Length + ti * 3 + 2] = m_Edges * 8;
			}
			else
			{
				trianglesCover[trianglesBarrel.Length + ti * 3 + 2] = m_Edges * 8 + ti + 1;
			}
		}

		mesh.subMeshCount = 2;
		mesh.SetTriangles(trianglesBarrel, 0);
		mesh.SetTriangles(trianglesCover, 1);
	}

	private void OnDrawGizmos()
	{
		if (vertices == null)
			return;
		
		for (int i = 0; i < vertices.Length; i++)
		{
			//Gizmos.color = Color.black;
			//Gizmos.DrawSphere(mesh.vertices[i], 0.1f);

			Gizmos.color = Color.yellow;
			Gizmos.DrawRay(vertices[i], mesh.normals[i].normalized / 4);
		}
	}
}
