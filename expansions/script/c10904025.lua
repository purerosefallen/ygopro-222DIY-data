--英灵刻使 爱丽丝
local m=10904025
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,cm.ffilter,aux.FilterBoolFunction(Card.IsType,TYPE_FUSION),false)
    aux.EnablePendulumAttribute(c,false) 
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_LSCALE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
    e3:SetValue(0)
    c:RegisterEffect(e3)
    local e9=e3:Clone()
    e9:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e9)  
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,1)
    e4:SetTarget(aux.TRUE)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetTarget(cm.sumlimit)
    c:RegisterEffect(e7)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90953320,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(cm.drcon)
    e1:SetTarget(cm.drtg)
    e1:SetOperation(cm.drop)
    c:RegisterEffect(e1)
end
function cm.ffilter(c)
    return c:IsSetCard(0x237) and c:IsType(TYPE_LINK)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
    local tg=eg:GetFirst()
    return eg:GetCount()==1 and (tg:IsSummonType(SUMMON_TYPE_SYNCHRO) or tg:IsSummonType(SUMMON_TYPE_FUSION) or tg:IsSummonType(SUMMON_TYPE_LINK) or tg:IsSummonType(SUMMON_TYPE_XYZ)) and tg:IsSetCard(0x237)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end

