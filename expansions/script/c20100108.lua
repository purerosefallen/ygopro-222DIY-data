--ReLiveStage-Separation
require("expansions/script/c20100002")
local m=20100108
local cm=_G["c"..m]
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --+2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(cm.thcost)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
    --finish act
    local e3=Cirn9.FinishAct(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc99))
    e4:SetValue(500)
    c:RegisterEffect(e4)
    --actlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTargetRange(0,1)
    e5:SetValue(cm.aclimit)
    e5:SetCondition(cm.actcon)
    c:RegisterEffect(e5)
    cm.FinishAct=e3
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return (Duel.GetFlagEffect(tp,20100068)==0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,2)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil)==2 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Cirn9.RevueBgm(tp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if ct==0 then return end
    if ct>2 then ct=2 end
    local g=Duel.GetDecktopGroup(tp,ct)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")
end

function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
    local sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.HintSelection(sg)
    Duel.BreakEffect()
    local c=e:GetHandler()
    local sum=Group.GetSum(sg,Card.GetAttack)
    local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local fc=tg:GetFirst()
    while fc do 
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-sum)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        fc:RegisterEffect(e1)
        fc=tg:GetNext()
    end
    local desg=tg:Filter(Card.IsAttack,nil,0)
    local desc=Duel.Destroy(desg,REASON_EFFECT)
    if (desc>0) then
        Duel.Damage(1-tp,desc*500,REASON_EFFECT)
    end
end
function cm.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.cfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xc99) and c:IsControler(tp)
end
function cm.actcon(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a and cm.cfilter(a,tp)) or (d and cm.cfilter(d,tp))
end