--ReLive-Claudine
local m=20100076
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --SpecialSummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.drtg)
    e1:SetOperation(cm.drop)
    c:RegisterEffect(e1)    
    --To hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)  
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(Cirn9.clcost)
    e3:SetCondition(Cirn9.clcon)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.tfilter(c,code,e,tp)
    return c:IsSetCard(0xc99) and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0xc99)
        and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end

function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,cm.tfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
    if sg:GetCount()>0 then
        if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e) then
            e:GetHandler():AddCounter(0xc99,1)
        end
    end
end
function cm.thfilter(c,e,tp)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        if Duel.SendtoHand(sg,nil,REASON_EFFECT) and e:GetHandler():IsRelateToEffect(e) then
            e:GetHandler():AddCounter(0xc99,1)
        end
    end
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end
    if not Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tg=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=tg:GetFirst()
    if not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(math.ceil(atk/2))
        tc:RegisterEffect(e1)
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            e2:SetValue(math.ceil(atk/2))
            c:RegisterEffect(e2)
        end
    end
end