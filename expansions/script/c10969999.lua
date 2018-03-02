--零点舞姬
local m=10969999
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(cm.condition4)
    e1:SetValue(cm.efilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(1,1)
    e2:SetCondition(cm.condition)
    e2:SetValue(cm.aclimit)
    c:RegisterEffect(e2)    
    local e3=e2:Clone()
    e3:SetCondition(cm.condition2)
    e3:SetValue(cm.aclimit2)
    c:RegisterEffect(e3)    
    local e4=e2:Clone()
    e4:SetCondition(cm.condition3)
    e4:SetValue(cm.aclimit3)
    c:RegisterEffect(e4)   
end
function cm.filter(c)
    return c:IsType(TYPE_MONSTER)
end
function cm.condition(e)
    return not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.filter2(c)
    return c:IsType(TYPE_SPELL)
end
function cm.condition2(e)
    return not Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.aclimit2(e,re,tp)
    return re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.filter3(c)
    return c:IsType(TYPE_TRAP)
end
function cm.condition3(e)
    return not Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.aclimit3(e,re,tp)
    return re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.condition4(e)
    return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.efilter(e,re)
    return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end
