#ifndef MIND_S_CRAWL_SIMULATIONMAP_CUH
#define MIND_S_CRAWL_SIMULATIONMAP_CUH


#include "MapNode.cuh"
#include "fucking_shit.cuh"
#include "common.cuh"


/// Object describing a simulation's map
class SimulationMap
{
public:
    /**
     * Creates a `SimulationMap` object and a grid of nodes
     *
     * @param polyhedron The polyhedron in simulation
     */
    __device__ SimulationMap(Polyhedron *polyhedron);

    /// Forbids copying `SimulationMap` objects
    __host__ __device__ SimulationMap(const SimulationMap &) = delete;

    /// Destructs a `SimulationMap` object
    __device__ ~SimulationMap();


    /**
     * Returns coordinates of neighbor node with or without projection on polyhedron
     *
     * @param current_node_id Index of the node whose neighbor is searched
     * @param top_direction Direction vector from current node to its top neighbor
     * @param angle Angle between the top neighbor node and the neighbor node whose index is searched
     *              relative to current node, clockwise is positive direction
     * @param do_projection If `true`, counted coordinates will be projected on polyhedron, otherwise they will not
     *
     * @returns Coordinates of neighbor node projected on polyhedron if `do_projection` is `true`,
     *          coordinates of neighbor node without projection on polyhedron otherwise
     */
    __device__ SpacePoint count_neighbor_node_coordinates(int current_node_id, SpacePoint top_direction, double angle,
                                                          bool do_projection) const;


    /**
     * Finds the nearest node to the given point
     *
     * @param point_coordinates Coordinates of the point that the closest node is searched to
     *
     * @returns The index of the found node in `nodes` array
     */
    __device__ int find_nearest_node_to_point(SpacePoint point_coordinates) const;


    /**
     * Counts direction vector from neighbor of current node to its top neighbor and sets it to `nodes_direction` array
     *
     * @param current_node_id Index of the node whose neighbor was searched
     * @param neighbor_node_id Index of neighbor node
     * @param nodes_directions Pointer to the array of direction vectors to the top neighbor node from each node
     * @param angle Angle between the top neighbor node and the neighbor node whose index is searched
     *              relative to current node, clockwise is positive direction
     */
    __device__ void set_direction_to_top_neighbor(int current_node_id, int neighbor_node_id,
                                                  SpacePoint **nodes_directions, double angle) const;


    /**
     * Returns the index of nearest node to neighbor in `nodes` array, if their coordinates are almost the same
     * or if `create_new_nodes` is `false`
     *
     * Creates new node in given coordinates if it does not exists and if it is possible and returns its index
     *
     * Returns `-1` if node cannot be created and `create_new_nodes` is `true`
     *
     * Node cannot be created if on the face it belongs to an another node exists and
     * their directions to the top neighbor are not the same
     *
     * @param current_node_id Index of the node whose neighbor is searched
     * @param nodes_directions Pointer to the array of direction vectors to the top neighbor node from each node
     * @param angle Angle between the top neighbor node and the neighbor node whose index is searched
     *              relative to current node, clockwise is positive direction
     * @param create_new_nodes `true` if new node is allowed to be created, `false` otherwise
     *
     * @returns The index of neighbor node if it has existed or was created, `-1` otherwise
     */
    __device__ int get_neighbor_node_id(int current_node_id, SpacePoint **nodes_directions, double angle,
                                        bool create_new_nodes);


    /**
     * Returns the number of nodes in the simulation
     *
     * @returns The number of nodes on the map
     *
     * @note This number is never ever changed during the existence of the object
     */
    __device__ int get_n_of_nodes() const;

    /**
     * Returns the number of nodes in the simulation
     *
     * @overload SimulationMap::get_n_of_nodes
     */
    __global__ friend void get_n_of_nodes(const SimulationMap *simulation_map, int *return_value);


    /// The array of nodes on the map
    MapNode *nodes;

    /// The polyhedron simulation is runned on
    Polyhedron *const polyhedron;

private:
    /// The number of nodes on the map
    int n_of_nodes;
};

#endif //MIND_S_CRAWL_SIMULATIONMAP_CUH
