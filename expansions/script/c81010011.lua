--安娜斯塔西娅
function c81010011.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),3,3) 
    --maintain
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c81010011.mtcon)
    e1:SetOperation(c81010011.mtop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c81010011.value)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0xff,0xff)
    e3:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e3)
end
function c81010011.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c81010011.mtop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,15)
    if g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==15 then
        Duel.DisableShuffleCheck()
        Duel.Remove(g,POS_FACEDOWN,REASON_COST)
    else
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
function c81010011.value(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,0)*300
end