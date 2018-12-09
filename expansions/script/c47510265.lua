--海与荣光之神 波塞冬
function c47510265.initial_effect(c)
    --revive limit
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --special summon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510265.psplimit)
    c:RegisterEffect(e1)  
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e2:SetCondition(c47510265.spcon)
    e2:SetOperation(c47510265.spop)
    c:RegisterEffect(e2)   
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c47510265.desop)
    c:RegisterEffect(e3)
    --sunmoneffect
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,47510000)
    e4:SetCost(c47510265.cost)
    e4:SetTarget(c47510265.thtg)
    e4:SetOperation(c47510265.thop)
    c:RegisterEffect(e4)
    c47510265.ss_effect=e4 
    --atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetTarget(c47510265.bftg)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
    local e8=e5:Clone()
    e8:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e8)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetTarget(c47510265.bftg1)
    e6:SetValue(-1000)
    c:RegisterEffect(e6)
    e9=e6:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)
    --xyzchange
    local e7=Effect.CreateEffect(c)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetCountLimit(1,47510248)
    e7:SetRange(LOCATION_PZONE)
    e7:SetCost(c47510265.xcost)
    e7:SetTarget(c47510265.xtg)
    e7:SetOperation(c47510265.xop)
    c:RegisterEffect(e7)
end
function c47510265.pefilter(c)
    return c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510265.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510265.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510265.rfilter(c,tp)
    return c:IsLevelAbove(6) and c:IsType(TYPE_PENDULUM) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510265.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function c47510265.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510265.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47510265.mzfilter,ct,nil,tp))
end
function c47510265.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510265.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:Select(tp,2,2,nil)
    elseif ft==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510265.mzfilter,1,1,nil,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g2=rg:Select(tp,1,1,g:GetFirst())
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510265.mzfilter,2,2,nil,tp)
    end
    Duel.Release(g,REASON_COST)
end
function c47510265.bftg(e,c)
    return c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510265.bftg1(e,c)
    return c:GetAttribute()~=ATTRIBUTE_WATER
end
function c47510265.xfilter(c)
    return c:IsSummonableCard()
end
function c47510265.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510265.xfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47510265.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    e:SetLabel(g:GetFirst():GetRace())
    Duel.SendtoGrave(g,REASON_COST)
end
function c47510265.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function c47510265.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c47510265.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c47510265.xop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local race=e:GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ADD_RACE)
    e1:SetValue(race)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510265.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c47510265.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c47510265.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
    sg=Duel.GetOperatedGroup()
    local d1=0
    local d2=0
    local tc=sg:GetFirst()
    while tc do
        if tc then
            if tc:GetPreviousControler()==0 then d1=d1+1
            else d2=d2+1 end
        end
        tc=sg:GetNext()
    end
    if d1>0 then Duel.Draw(0,d1,REASON_EFFECT) end
    if d2>0 then Duel.Draw(1,d2,REASON_EFFECT) end
end
function c47510265.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510265.thfilter(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47510265.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510265.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47510265.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510265.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510265.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47510265.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end