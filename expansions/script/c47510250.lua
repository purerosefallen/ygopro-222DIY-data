--铃铛天使 叮咚
function c47510250.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    --synchro
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510250,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510250)
    e1:SetTarget(c47510250.sctg)
    e1:SetOperation(c47510250.scop)
    c:RegisterEffect(e1)   
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510250,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCondition(c47510250.drcon)
    e2:SetTarget(c47510250.drtg)
    e2:SetOperation(c47510250.drop)
    c:RegisterEffect(e2) 
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510251)
    e3:SetOperation(c47510250.ceop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510250.cost)
    e5:SetOperation(c47510250.ssop)
    c:RegisterEffect(e5)
    c47510250.ss_effect=e5
    --synchro limit
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetValue(c47510250.synlimit)
    c:RegisterEffect(e6)
end
function c47510250.synlimit(e,c)
    if not c then return false end
    return not c:IsType(TYPE_PENDULUM)
end
function c47510250.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_EXTRA) and r==REASON_SYNCHRO
end
function c47510250.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47510250.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)~=0 then
        Duel.ShuffleHand(tp)
        Duel.BreakEffect()
        Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
    end
end
function c47510250.scfilter1(c,e,tp,mc)
    local mg=Group.FromCards(c,mc)
    return c:IsCanBeSynchroMaterial() and Duel.IsExistingMatchingCard(c47510250.scfilter2,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c47510250.scfilter2(c,mg)
    return c:IsSynchroSummonable(nil,mg)
end
function c47510250.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
        and Duel.IsExistingTarget(c47510250.scfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47510250.scfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c47510250.scop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
    local mg=Group.FromCards(c,tc)
    if Duel.GetLocationCountFromEx(tp,tp,mg)<=0 then return end
    local g=Duel.GetMatchingGroup(c47510250.scfilter2,tp,LOCATION_EXTRA,0,nil,mg)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
    end
end
function c47510250.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)
end
function c47510250.ceop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectMatchingCard(tp,c47510250.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e1)
        Duel.SpecialSummonComplete()
        end
    end
end
function c47510250.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510250.ssop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_SZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end