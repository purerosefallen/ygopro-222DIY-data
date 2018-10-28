--高机动型杰钢
local m=47530006
local cm=_G["c"..m]
function c47530006.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),3,4,c47530006.lcheck)
    c:EnableReviveLimit() 
    --immune (FAQ in Card Target)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetTarget(c47530006.target)
    e1:SetValue(c47530006.efilter)
    c:RegisterEffect(e1)   
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2) 
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530006,0))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c47530006.tgtg)
    e3:SetOperation(c47530006.tgop)
    c:RegisterEffect(e3)
    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BATTLED)
    e4:SetTarget(c47530006.rgtg)
    e4:SetOperation(c47530006.rgop)
    c:RegisterEffect(e4)
end
function c47530006.lcheck(g,lc)
    return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c47530006.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47530006.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47530006.filter(c,atk)
    return c:IsFaceup() and c:IsDefenseBelow(atk) or c:IsType(TYPE_LINK)
end
function c47530006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47530006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
    local g=Duel.GetMatchingGroup(c47530006.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c47530006.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local g=Duel.GetMatchingGroup(c47530006.filter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    if Duel.MoveSequence(c,nseq) then
        Duel.SendtoGrave(g,REASON_RULE)
    end
end
function c47530006.rgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:GetDefense()<=c:GetAttack() or tc:IsType(TYPE_LINK) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c47530006.rgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:GetDefense()<=c:GetAttack() or tc:IsType(TYPE_LINK) then  
        Duel.SendtoGrave(tc,REASON_RULE) 
    end
end