--ReLive-Maya
local m=20100074
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --attack up
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.atktg)
    e1:SetCost(Cirn9.ap1)
    e1:SetOperation(cm.atkop)
    c:RegisterEffect(e1)
    --special summon from hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)   
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.cltg)
    e3:SetOperation(cm.clop)
    c:RegisterEffect(e3)   
    cm.ClimaxAct=e3
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then  
        c:AddCounter(0xc99,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(300)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(20100070,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end

function cm.spfilter(c,e,tp)
    return c:IsSetCard(0xc99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e) then
            Duel.BreakEffect()
            e:GetHandler():AddCounter(0xc99,1)
            g:GetFirst():AddCounter(0xc99,1)
        end
    end
end
function cm.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(cm.ftarget)
    e1:SetLabel(e:GetHandler():GetFieldID())
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp)
    if not Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp) then return end
    Duel.Hint(11,0,aux.Stringid(m,3)) 
    local tc=e:GetHandler()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        --local g=Duel.GetMatchingGroup(cm.atkfi lter,tp,LOCATION_MZONE,0,tc)
        --local atk=g:GetSum(Card.GetAttack)
        local e4=Effect.CreateEffect(tc)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_UPDATE_ATTACK)
        e4:SetCondition(cm.atkcon)
        e4:SetValue(cm.atkval)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e4)
    end
end
function cm.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function cm.atkcon(e)
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function cm.atkval(e,c,tp)
    local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,c)
    local atk=g:GetSum(Card.GetAttack)
    return atk
end
