--卡碧尼MK-II
local m=47530005
local cm=_G["c"..m]
function c47530005.initial_effect(c)
    c:SetSPSummonOnce(47530005)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,3)
    c:EnableReviveLimit()  
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530005,1))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47530005.tgcon)
    e1:SetTarget(c47530005.tgtg)
    e1:SetOperation(c47530005.tgop)
    c:RegisterEffect(e1)  
    --repeat attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530005,0))
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetTarget(c47530005.thtg)
    e1:SetOperation(c47530005.thop)
    c:RegisterEffect(e1)   
end
function c47530005.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47530005.tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c47530005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c47530005.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c47530005.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47530005.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT) then
        local code=tc:GetOriginalCode()
        local atk=tc:GetTextAttack()
        c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
    end
end
function c47530005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and tc:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c47530005.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if c==tc then tc=Duel.GetAttackTarget() end
    if tc and tc:IsRelateToBattle() then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end