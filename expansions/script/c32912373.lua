--Spiral Drill - Drill Break Warrior
function c32912373.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,32912371,32912372,1,true,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c32912373.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c32912373.sprcon)
    e2:SetOperation(c32912373.sprop)
    c:RegisterEffect(e2)
    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c32912373.aclimit)
    e3:SetCondition(c32912373.actcon)
    c:RegisterEffect(e3)
    --pierce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e5:SetCondition(c32912373.damcon)
    e5:SetOperation(c32912373.damop)
    c:RegisterEffect(e5)
    --atk
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(32912373,1))
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e6:SetCountLimit(1)
    e6:SetCondition(c32912373.atkcon)
    e6:SetCost(c32912373.atkcost)
    e6:SetOperation(c32912373.atkop)
    c:RegisterEffect(e6)
end
function c32912373.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c32912373.cfilter(c)
    return (c:IsFusionCode(32912371) or c:IsFusionCode(32912372))
        and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c32912373.spfilter1(c,tp,g)
    return g:IsExists(c32912373.spfilter2,1,c,tp,c)
end
function c32912373.spfilter2(c,tp,mc)
    return (c:IsFusionCode(32912371) and mc:IsFusionCode(32912372)
        or c:IsFusionCode(32912372) and mc:IsFusionCode(32912371))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c32912373.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c32912373.cfilter,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c32912373.spfilter1,1,nil,tp,g)
end
function c32912373.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c32912373.cfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=g:FilterSelect(tp,c32912373.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=g:FilterSelect(tp,c32912373.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c32912373.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c32912373.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c32912373.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c32912373.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c32912373.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c32912373.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST,nil)
end
function c32912373.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=c:GetBaseAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(atk*2)
        c:RegisterEffect(e1)
    end
end