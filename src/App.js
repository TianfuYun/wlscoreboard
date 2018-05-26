import React, { Component } from 'react';
import './App.css';
import firebase from 'firebase';
import { Button, Table } from 'react-bootstrap';

class App extends Component {
  constructor() {
    super();
    this.state = {
      data: []
    }
  }

  componentWillMount() {
    firebase.database().ref().child('currentgroup').on('value', snap => {
      this.setState({
        data: snap.val()
      });
    });
  }

  render() {
    return (
      <div className="App">
        <ScoreBoard data={this.state.data} />
      </div>
    );
  }
}

class ScoreBoard extends Component {
  render() {
    const data = this.props.data;
    const rows = [];

    if (data != null) {
      for (let i = 0; i < data.length; i++) {
        rows.push(<ScoreBoardRow data={data[i]} key={i} />);
      }
    }
    
    return (<Table><TableHeader /><tbody>{rows}</tbody></Table>);
  }
}

const TableHeader = () => {
  return (
    <thead>
      <tr>
        <th className='start'>Start</th>
        <th className='start'>Klass</th>
        <th className='bw'>Vikt</th>
        <th className='name'>Namn</th>
        <th className='club'>Klubb</th>
        <th className='weight3' colSpan='3'>Ryck</th>
        <th className='weight3' colSpan='3'>Stöt</th>
        <th className='rank'>Totalt</th>
        <th className='rank'>Plac.</th>
      </tr>
    </thead>
  );
}

class ScoreBoardRow extends Component {
  render() {
    const data = this.props.data;

    //green if good lift, etc.
    function Color(props) {
      if (props.weight === '' || props.weight === undefined) {
        return null;
      } else if (props.weight > 0) {
        return <Button className='weightbutton' bsStyle='success' block>{props.weight}</Button>;
      } else if (props.weight.substring(0, 1) === 'r') { //requested weight
        return <Button className='weightbutton' block>{props.weight.substring(1)}</Button>;
      } else if (props.weight.substring(0, 1) === '(') { //bad lift
        return <Button className='weightbutton' bsStyle='danger' block>{props.weight.slice(1, -1)}</Button>;
      } else if (props.weight.substring(0, 1) === 'c') { //current
        return <Button className='weightbutton' bsStyle='warning' block>{props.weight.substring(1)}</Button>;
      } else {
        return null;
      }
    }

    return (
      <tr>
        <td className='start'>{data[0]}</td>
        <td className='start'>{data[2]}</td>
        <td className='bw'>{data[3]}</td>
        <td className='name'>{data[1]}</td>
        <td className='club'>{data[4]}</td>
        <td className='weight'><Color weight={data[5]} /></td>
        <td className='weight'><Color weight={data[6]} /></td>
        <td className='weight'><Color weight={data[7]} /></td>
        <td className='weight'><Color weight={data[9]} /></td>
        <td className='weight'><Color weight={data[10]} /></td>
        <td className='weight'><Color weight={data[11]} /></td>
        <td className='rank'>{data[13]}</td>
        <td className='rank'>{data[14]}</td>
      </tr>
    );
  }
}

export default App;
