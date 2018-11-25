--Spiral Drill - Warrior's Combined Courage 
function c32912375.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c32912375.lkcheck,2,2,c32912375.lcheck)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c32912375.matcheck)
    c:RegisterEffect(e1)
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetCondition(c32912375.damcon)
    e3:SetOperation(c32912375.damop)
    c:RegisterEffect(e3)
    --DEF change
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(32912375,0))
    e4:SetCategory(CATEGORY_DEFCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c32912375.defcost)
    e4:SetOperation(c32912375.defop)
    c:RegisterEffect(e4)
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(32912375,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCountLimit(1,32912375)
    e5:SetCondition(c32912375.thcon)
    e5:SetTarget(c32912375.thtg)
    e5:SetOperation(c32912375.thop)
    c:RegisterEffect(e5)
end
function c32912375.lkcheck(c)
    return c:IsSetCard(0x205)
end
function c32912375.lcheck(g,lc)
    return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c32912375.matfilter(c)
    return c:IsSetCard(0x205) and c:GetOriginalLevel()>=0
end
function c32912375.matcheck(e,c)
    local g=c:GetMaterial():Filter(c32912375.matfilter,nil)
    local atk=g:GetSum(Card.GetOriginalLevel)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk*100)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
end
function c32912375.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c32912375.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c32912375.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c32912375.defop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c32912375.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c32912375.thfilter(c)
    return c:IsSetCard(0x205) and c:IsAbleToHand()
end
function c32912375.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32912375.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32912375.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32912375.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end