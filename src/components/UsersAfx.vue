<template>
  <div class="container">
    <h3> AFX Roster!</h3>
    <table class="table">
      <thead>
        <tr>
          <th scope="col">#</th>
          <th scope="col">Name</th>
          <th scope="col">Email</th>
          <th scope="col">Phone</th>
          <th scope="col">Year</th>
          <th scope="col">Dance Experience</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" v-bind:key="user.id"> 
          <th scope="row">{{user.id}}</th>
          <td>{{user.name}}</td>
          <td>{{user.email}}</td>
          <td>{{user.phone}}</td>
          <td>{{user.year}}</td>
          <td>{{user.danceExperience}}</td>
        </tr>
      </tbody>
    </table> 
  </div> 
</template>

<script>
//   import axios from 'axios';
    import json from '../dancersData.json'
    export default {
        data() {
            return {
                users: json
            }
        }
    }
    // export default {
    // name: 'UsersAfx',
    // data() {
    //     return {
    //         users: null,
    //     };
    // },
    // created: function() {
    //     axios
    //         .get('https://jsonplaceholder.typicode.com/users')
    //         .then(res => {
    //             this.users = res.data;
    //         })
    //     }

    // }
</script>

<style>
  h3 {
    margin-bottom: 5%;
  }
</style>