import { Link } from "gatsby"
import PropTypes from "prop-types"
import React from "react"
import { View, Text } from 'react-native';

import { useREM } from 'react-native-web-hooks';

const Header = ({ siteTitle }) => {
    
    const accessibilityRole: any = 'banner'
    return (
  <View 
    accessibilityRole={accessibilityRole}
    style={{
      backgroundColor: `rebeccapurple`,
      marginBottom: useREM(1.45),
    }}
  >
    <View
      style={{
        maxWidth: 960,
        paddingVertical:  useREM(1.45),
        paddingHorizontal: useREM(1.0875),
      }}
    >
      <Text accessibilityRole="header" style={{ fontWeight: 'bold', fontSize: useREM(2.25) }}>
        <Link
          to="/"
          style={{
            color: `white`,
            textDecoration: `none`,
          }}
        >
          {siteTitle}
        </Link>
      </Text>
    </View>
  </View>
)
}
Header.propTypes = {
  siteTitle: PropTypes.string,
}

Header.defaultProps = {
  siteTitle: ``,
}

export default Header
