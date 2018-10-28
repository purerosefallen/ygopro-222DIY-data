--觉醒十天众 奥克托
local m=47591788
local cm=_G["c"..m]
function c47591788.initial_effect(c)
     --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --检索
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c47591788.poscon)
    e1:SetTarget(c47591788.thtg)
    e1:SetOperation(c47591788.thop)
    c:RegisterEffect(e1)  
    --double atk
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_END+EFFECT_UPDATE_ATTACK)
    e4:SetValue(1000)
    c:RegisterEffect(e4)
    --sokushi
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BATTLE_END)
    e4:SetCountLimit(1)
    e4:SetTarget(c47591788.tgtg)
    e4:SetOperation(c47591788.tgop)
    c:RegisterEffect(e4)
    --battle
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
end
function c47591788.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and tc:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c47591788.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if c==tc then tc=Duel.GetAttackTarget() end
    if tc and tc:IsRelateToBattle() then
        Duel.SendtoGrave(tc,REASON_RULE)
    end
    if c:IsRelateToEffect(e) and c:IsChainAttackable() then
        Duel.ChainAttack()
    end
end
function c47591788.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47591788.filter(c)
    return c:IsCode(47591008) and c:IsAbleToHand()
end
function c47591788.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591788.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591788.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591788.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47591788.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47591788.atkop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.Draw(tp,1,REASON_EFFECT)
    if ct==0 then return end
    local tc=Duel.GetOperatedGroup():GetFirst()
    Duel.ConfirmCards(1-tp,tc)
    Duel.ShuffleHand(tp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(800)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
        c:RegisterEffect(e3)
    end
end