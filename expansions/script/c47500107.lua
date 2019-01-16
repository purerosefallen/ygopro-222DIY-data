--超时空龙 时空暴君
local m=47500107
local cm=_G["c"..m]
function c47500107.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),10,99,c47500107.ovfilter,aux.Stringid(47500107,0),99,c47500107.xyzop)
    c:EnableReviveLimit() 
    --spsummon limit
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.xyzlimit)
    c:RegisterEffect(e0)  
    --Tachyon Transmigration
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47500107.condition)
    e1:SetCountLimit(1,47500107+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(c47500107.cost)
    e1:SetOperation(c47500107.operation)
    c:RegisterEffect(e1)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetCondition(c47500107.regcon)
    e3:SetOperation(c47500107.regop)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47500107.discon2)
    e5:SetOperation(c47500107.disop2)
    c:RegisterEffect(e5) 
end
c47500107.list={
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
function c47500107.ovfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_XYZ) and c:IsRank(8) and c:IsRace(RACE_DRAGON) and c:GetBaseAttack()==3000 and c:GetBaseDefense()==2500
end
function c47500107.xyzop(e,tp,chk)
    if chk==0 then return true end
    e:GetHandler():RegisterFlagEffect(47500107,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function c47500107.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetTurnPlayer()==tp
end
function c47500107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47500107.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,e:GetHandler())
    if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
        Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
        Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
        Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_SKIP_TURN)
        e1:SetTargetRange(0,1)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
        Duel.RegisterEffect(e1,tp)
        c:RegisterFlagEffect(47501107,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,2)
        Duel.RegisterEffect(e1,tp)
        Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
        Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
        Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetCode(EFFECT_CANNOT_EP)
        e2:SetTargetRange(1,0)
        e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
        Duel.RegisterEffect(e2,tp)
    end
end
function c47500107.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47501107)>0
end
function c47500107.exatk(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetFlagEffect(tp,47501117)*1
    return val
end
function c47500107.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1500)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE,2)
    c:RegisterEffect(e1)
    c:RegisterFlagEffect(tp,47501117,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(c47500107.exatk)
    e4:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
    c:RegisterEffect(e4)
end
function c47500107.nfilter(e,c)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c==e:GetHandler()
end
function c47500107.discon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():GetFlagEffect(47511107)~=0 then return end
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) or rp==tp then return false end
    if c47500107.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47500107.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47500107.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47500107.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47500107.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47500107.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47500107.disop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoHand(rc,tp,REASON_EFFECT)
        c:RegisterFlagEffect(47511107,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
    end
end