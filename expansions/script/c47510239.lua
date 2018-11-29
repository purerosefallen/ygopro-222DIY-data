--神魔之钥 阿米拉
local m=47510239
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510239.initial_effect(c)
    aux.EnablePendulumAttribute(c) 
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510239,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c47510239.otcon)
    e1:SetOperation(c47510239.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
    --  
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510239.thop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510239,2))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510240)
    e5:SetCondition(c47510239.sumcon)
    e5:SetTarget(c47510239.sumtg)
    e5:SetOperation(c47510239.sumop)
    c:RegisterEffect(e5) 
    --Change
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510239,3))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1,47510239)
    e6:SetCost(c47510239.chcost)
    e6:SetTarget(c47510239.changetg)
    e6:SetOperation(c47510239.changeop)
    c:RegisterEffect(e6)  
end
function c47510239.otfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(5)
end
function c47510239.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c47510239.otfilter,tp,LOCATION_PZONE,0,1,c,tp)
end
function c47510239.otop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local sg=Duel.SelectMatchingCard(tp,c47510239.otfilter,tp,LOCATION_PZONE,0,1,1,c,tp)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47510239.thfilter(c,e,tp,zone)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(7) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510239.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectMatchingCard(tp,c47510239.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47510239.sumfilter(c)
    return c:IsFacedown() or not c:IsRace(RACE_FAIRY)
end
function c47510239.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
    return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c47510239.sumfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c47510239.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c47510239.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pos=0
    if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
    if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
    if pos==0 then return end
    if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
        Duel.Summon(tp,c,true,nil,1)
    else
        Duel.MSet(tp,c,true,nil,1)
    end
end
function c47510239.chfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(7)
end
function c47510239.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
    Duel.SendtoGrave(tp,c47510239.chfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c47510239.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510239.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    c:ReplaceEffect(tcode,0,0)
end