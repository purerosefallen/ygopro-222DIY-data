--ReLive-Nana
require("expansions/script/c20100002")
local m=20100068
local cm=_G["c"..m]
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)    
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.indcon)
    e2:SetTarget(cm.indtg)
    e2:SetCost(Cirn9.ap2)
    e2:SetOperation(cm.indop)
    c:RegisterEffect(e2) 
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetTarget(cm.sptg)
    e3:SetCost(Cirn9.clcost)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3) 
    cm.ClimaxAct=e3 
end

function cm.filter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoHand(tc,nil,REASON_EFFECT) and c:IsRelateToEffect(e) then
            Duel.BreakEffect()
            c:AddCounter(0xc99,1)
            Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP() or Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_FZONE,0,1,nil,0xc99)
end
function cm.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():AddCounter(0xc99,1)
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        if fc and fc:IsFaceup() and fc:IsSetCard(0xc99) then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_IMMUNE_EFFECT)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e2:SetRange(LOCATION_FZONE)
            e2:SetValue(cm.efilter)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            fc:RegisterEffect(e2) 
        end
    end
end
function cm.efilter(e,re,tp)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end

function cm.spfilter(c,e,tp,tid)
    return c:GetTurnID()==(tid-1) and c:IsReason(REASON_DESTROY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tid=Duel.GetTurnCount()
    if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetLP(tp,99)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp) then return end
    Duel.Hint(11,0,aux.Stringid(m,3))   
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local tid=Duel.GetTurnCount()
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
    while g:GetCount()>0 and ft>0 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SpecialSummonStep(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
        ft=ft-1
        g:RemoveCard(sg:GetFirst())
    end
    Duel.SpecialSummonComplete()
end