--魔禁 神裂火炽
function c5012611.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x250),3,3)
    c:EnableReviveLimit()   
    --asdasfasfdada
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(c5012611.op)
    c:RegisterEffect(e1)
end
function c5012611.lcheck(g,lc)
    return g:IsExists(Card.IsSetCard,1,nil,0x250)
end
function c5012611.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local b1=true
    local b2=(Duel.GetTurnPlayer()==tp and not c:IsHasEffect(EFFECT_EXTRA_ATTACK))
    local op=0
    if b1 and b2 then
       op=Duel.SelectOption(tp,aux.Stringid(5012611,0),aux.Stringid(5012611,1))
    else
       op=Duel.SelectOption(tp,aux.Stringid(5012611,0))
    end
    if op==0 then
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_UPDATE_ATTACK)
       e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE_START,2)
       e1:SetValue(1000)
       c:RegisterEffect(e1)
       local e2=Effect.CreateEffect(c)
       e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
       e2:SetCode(EVENT_BATTLE_START)
       e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE_START,2)
       e2:SetOperation(c5012611.lpop)
       c:RegisterEffect(e2)
    else
       local e3=Effect.CreateEffect(c)
       e3:SetType(EFFECT_TYPE_SINGLE)
       e3:SetCode(EFFECT_EXTRA_ATTACK)
       e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
       e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE_START,2)
       e3:SetValue(6)
       c:RegisterEffect(e3)
       local e4=Effect.CreateEffect(c)
       e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
       e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
       e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE_START,2)
       e4:SetCondition(c5012611.damcon)
       e4:SetOperation(c5012611.damop)
       c:RegisterEffect(e4)
    end
end
function c5012611.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and ev>=Duel.GetLP(1-tp) and Duel.GetAttacker()==c
end
function c5012611.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,0)
    Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
function c5012611.lpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local atk=c:GetAttack()
    if not bc or bc:IsFacedown() or not bc:IsDefenseAbove(0) or atk==bc:GetDefense() then return end
    Duel.Hint(HINT_CARD,0,5012611)
    local lp=math.abs(atk-bc:GetDefense())
    local lp2=Duel.GetLP(1-tp)
    local clp=((lp>lp2) and lp2 or lp2-lp)
    Duel.SetLP(1-tp,clp)
end