--斯巴达 姬塔
function c47500103.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47500103.fusfilter1,aux.FilterBoolFunction(Card.IsCode,47500000),1,true,true)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47500103.sprcon)
    e0:SetOperation(c47500103.sprop)
    c:RegisterEffect(e0)   
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47500103.psplimit)
    c:RegisterEffect(e1)
    --immune (FAQ in Card Target)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47500103.target)
    e2:SetValue(c47500103.efilter)
    c:RegisterEffect(e2)  
    local e5=e2:Clone()
    e5:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(1)
    c:RegisterEffect(e3)    
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e4)
    --muteki
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_CHAIN_SOLVING)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47500103.discon2)
    e8:SetOperation(c47500103.disop2)
    c:RegisterEffect(e8) 
end
c47500103.card_code_list={47500000}
function c47500103.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47500103.psplimit(e,c,tp,sumtp,sumpos)
    return not c47500103.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47500103.fusfilter1(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c47500103.cfilter(c)
    return (c:IsCode(47500000) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER)))
        and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c47500103.spfilter1(c,tp,g)
    return g:IsExists(c47500103.spfilter2,1,c,tp,c)
end
function c47500103.spfilter2(c,tp,mc)
    return (c:IsRace(RACE_WARRIOR) and mc:IsCode(47500000) and c:IsAttribute(ATTRIBUTE_WATER)
        or c:IsCode(47500000) and mc:IsRace(RACE_WARRIOR) and mc:IsAttribute(ATTRIBUTE_WATER))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47500103.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47500103.cfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c47500103.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47500103.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47500103.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47500103.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47500103.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47500103.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47500103.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
c47500103.list={
        CATEGORY_DESTROY,
        CATEGORY_RELEASE,
        CATEGORY_REMOVE,
        CATEGORY_TOHAND,
        CATEGORY_TODECK,
        CATEGORY_TOGRAVE,
        CATEGORY_DECKDES,
        CATEGORY_HANDES,
        CATEGORY_POSITION,
        CATEGORY_CONTROL,
        CATEGORY_DISABLE,
        CATEGORY_DISABLE_SUMMON,
        CATEGORY_EQUIP,
        CATEGORY_DAMAGE,
        CATEGORY_RECOVER,
        CATEGORY_ATKCHANGE,
        CATEGORY_DEFCHANGE,
        CATEGORY_COUNTER,
        CATEGORY_LVCHANGE,
        CATEGORY_NEGATE,
}
function c47500103.nfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47500103.discon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():GetFlagEffect(47500103)~=0 then return end
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) or not rp==1-tp then return false end
    if c47500103.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47500103.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47500103.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47500103.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47500103.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47500103.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47500103.disop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateEffect(ev) then
        c:RegisterFlagEffect(47500103,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    end
end