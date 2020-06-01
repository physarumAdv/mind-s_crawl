#ifndef MIND_S_CRAWL_MAPNODE_CUH
#define MIND_S_CRAWL_MAPNODE_CUH


#include "SpacePoint.cuh"

class Particle;

class Polyhedron;


// TODO: add @see to the modified model description to the following docstring
/**
 * Object describing a node of `SimulationMap`
 *
 * This structure describes a node of a simulation map in the Jones' model modified for 3d space
 */
class MapNode
{
public:
    /**
     * Creates a `MapNode` object
     *
     * @param polyhedron The polyhedron to create node on
     * @param polyhedron_face_id The polyhedron's face to create node on
     * @param coordinates The coordinates of node to create node at
     */
    __device__ MapNode(Polyhedron *polyhedron, int polyhedron_face_id, SpacePoint coordinates);

    /// Forbids copying `MapNode` objects
    __host__ __device__ MapNode(const MapNode &) = delete;

    /// Destructs a `MapNode` object
    __device__ ~MapNode();


    /**
     * Sets the left neighbor, only if it was not set already
     *
     * @param value Pointer to new left neighbor
     *
     * @returns `true`, if the neighbor was not set already (so it is updated by the given value), otherwise `false`
     *
     * @note If the given value is `nullptr`, nothing happens, `false` is returned
     *
     * @note This operation is thread-safe
     */
    __device__ bool set_left(MapNode *value);

    /**
     * Sets the top neighbor, only if it was not set already
     *
     * @param value Pointer to new top neighbor
     *
     * @returns `true`, if the neighbor was not set already (so it is updated by the given value), otherwise `false`
     *
     * @note If the given value is `nullptr`, nothing happens, `false` is returned
     *
     * @note This operation is thread-safe
     */
    __device__ bool set_top(MapNode *value);

    /**
     * Sets the right neighbor, only if it was not set already
     *
     * @param value Pointer to new right neighbor
     *
     * @returns `true`, if the neighbor was not set already (so it is updated by the given value), otherwise `false`
     *
     * @note If the given value is `nullptr`, nothing happens, `false` is returned
     *
     * @note This operation is thread-safe
     */
    __device__ bool set_right(MapNode *value);

    /**
     * Sets the bottom neighbor, only if it was not set already
     *
     * @param value Pointer to new bottom neighbor
     *
     * @returns `true`, if the neighbor was not set already (so it is updated by the given value), otherwise `false`
     *
     * @note If the given value is `nullptr`, nothing happens, `false` is returned
     *
     * @note This operation is thread-safe
     */
    __device__ bool set_bottom(MapNode *value);


    /**
     * Returns a pointer to the left neighbor
     *
     * @returns Pointer to the left neighbor (`nullptr` if the neighbor is not set)
     */
    __device__ MapNode *get_left() const;

    /**
     * Returns a pointer to the top neighbor
     *
     * @returns Pointer to the top neighbor (`nullptr` if the neighbor is not set)
     */
    __device__ MapNode *get_top() const;

    /**
     * Returns a pointer to the right neighbor
     *
     * @returns Pointer to the right neighbor (`nullptr` if the neighbor is not set)
     */
    __device__ MapNode *get_right() const;

    /**
     * Returns a pointer to the bottom neighbor
     *
     * @returns Pointer to the bottom neighbor (`nullptr` if the neighbor is not set)
     */
    __device__ MapNode *get_bottom() const;


    __device__ bool contains_particle() const;

    /**
     * Attaches the given `Particle` to the node, if it is not occupied already
     *
     * @param p Pointer to the particle to be attached
     *
     * @returns `true`, if the particle was successfully attached (which means the node was not occupied before),
     *      otherwise `false`
     *
     * @note This operation is thread-safe
     *
     * @see MapNode::get_particle, MapNode::detach_particle
     */
    [[nodiscard]] __device__ bool attach_particle(Particle *p);

    /**
     * Returns a pointer to the attached particle
     *
     * @returns Pointer to the attached particle, if there is any, otherwise `nullptr`
     *
     * @see mapNode::attach_particle, MapNode::detach_particle
     */
    __device__ Particle *get_particle() const;

    /**
     * Marks the node as not occupied (not containing a particle) / Detaches particle from the node
     *
     * @note The operation is thread-safe
     *
     * @warning Detaching particle from a map node <b>does not</b> free memory, allocated for `Particle`, so if you want
     *      to free memory, you have to firstly obtain a pointer to the `Particle` if you don't have it yet (can be done
     *      via `get_particle()`), then detach the particle from it's node (call `detach_particle()`), and then free
     *      memory.
     *
     * @warning Remember about thread-safety: `MapNode` does not guarantee that the `Particle` being removed didn't change
     *      since calling `get_particle()`
     *
     * @see MapNode::attach_particle, MapNode::get_particle
     */
    __device__ void detach_particle();

    /**
     * Detaches the given `Particle` from the `MapNode`, if it is attached
     *
     * @param p Pointer to the `Particle` to be detached
     *
     * @returns `true`, if the given `Particle` was attached to the node (which means it was successfully removed),
     *      otherwise `false`
     *
     * @note This operation is thread-safe
     */
    __device__ bool detach_particle(Particle *p);


    /// Polyhedron containing the node
    Polyhedron *const polyhedron;

    /// Polyhedron's face the node is located on
    const int polyhedron_face_id;


    /// Trail value in the node
    double trail;

    /// Temporary trail value in the node (implementation-level field)
    double temp_trail;

    /// Whether there is food in the current node
    const bool contains_food;


    /// The node's coordinates
    const SpacePoint coordinates;


private:
    /// Pointer to a neighbor from the corresponding side
    MapNode *left, *top, *right, *bottom;


    /// Pointer to a particle attached to the node if it exists or TO WHATEVER otherwise
    Particle *particle;
};

#endif //MIND_S_CRAWL_MAPNODE_CUH
