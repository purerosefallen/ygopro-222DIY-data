--ReLive-Futaba
local m=20100072
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
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
    --special summon from grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)     
    --tohand&damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.filter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_REMOVED and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoHand(tc,nil,REASON_EFFECT) and c:IsRelateToEffect(e) then
            Duel.BreakEffect()
            c:AddCounter(0xc99,1)
            
        end
    end
end
function cm.spfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc99) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and c:IsRelateToEffect(e) then
            Duel.BreakEffect()
            c:AddCounter(0xc99,1)
            tc:AddCounter(0xc99,1)
        end
    end
end
function cm.clfilter(c)
    return c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.clfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.clfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.clfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local atk=g:GetFirst():GetAttack()
    if atk<0 then atk=0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        local atk=tc:GetAttack()
        if atk<0 then atk=0 end
        if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
            Duel.Damage(1-tp,atk,REASON_EFFECT)
        end
    end
end
