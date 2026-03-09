import React, { useState } from "react";
import { Text, View, TextInput, Button, FlatList, StyleSheet } from "react-native";
export default function App(){
  const [posts, setPosts] = useState([{id:'1', user:'ALT3R3D-PHO3NIX', text:'Rising through smoke.'}]);
  const [input, setInput] = useState("");
  return (
    <View style={styles.container}>
      <Text style={styles.title}>PhoenixForge Mobile</Text>
      <TextInput style={styles.input} placeholder="Post something..." placeholderTextColor="#999" value={input} onChangeText={setInput} />
      <Button title="Post" onPress={()=>{ setPosts([...posts,{id:Date.now().toString(),user:'You',text:input}]); setInput(""); }} />
      <FlatList data={posts} renderItem={({item})=> (
        <View style={styles.post}><Text style={styles.user}>{item.user}</Text><Text style={styles.text}>{item.text}</Text></View>
      )} />
    </View>
  )
}
const styles = StyleSheet.create({ container: { flex:1, backgroundColor:'#000', padding:20 }, title: { fontSize:24, color:'#fff', marginBottom:10 }, input:{ backgroundColor:'#222', color:'#fff', marginBottom:10, padding:8 }, post:{ padding:10, backgroundColor:'#111', marginVertical:5 }, user:{ fontWeight:'bold', color:'#facc15'}, text:{ color:'#fff'} })
