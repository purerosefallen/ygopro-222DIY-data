--圣夜的妖童 阿露露梅亚
function c47551107.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --dice
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47551107,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47551107)
    e1:SetTarget(c47551107.sptg2)
    e1:SetOperation(c47551107.spop)
    c:RegisterEffect(e1)
    --synchro limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetTarget(c47551107.synlimit)
    c:RegisterEffect(e2)
    --synchro level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
    e3:SetTarget(c47551107.syntg)
    e3:SetValue(1)
    e3:SetOperation(c47551107.synop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(47551107)
    e4:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e4)
    --spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47551107,4))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetRange(LOCATION_HAND)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCountLimit(1,47551108)
    e6:SetCondition(c47551107.rtcon)
    e6:SetTarget(c47551107.rttg)
    e6:SetOperation(c47551107.rtop)
    c:RegisterEffect(e6)
end
function c47551107.synlimit(e,c)
    return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function c47551107.thfilter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand() 
end
function c47551107.spfilter(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c47551107.tfilter2(c,e,tp)
    return c:IsSetCard(0x5d0) and c:IsType(TYPE_PENDULUM)
end
function c47551107.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47551107.tfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(c47551107.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) or Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c47551107.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.TossDice(tp,1)
    if d==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c47551107.thfilter,tp,LOCATION_EXTRA,0,1,2,nil)
        if g:GetCount()<1 then return end
        local sc=g:GetFirst()
        Duel.SendtoHand(sc,nil,REASON_EFFECT)    
    elseif d==2 or d==3 or d==4 or d==5 then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
            Duel.ShuffleHand(tp)
            Duel.BreakEffect()
            Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
        end
    elseif d==6 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47551107.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()<1 then return end
        local sc=g:GetFirst()
        Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        sc:RegisterEffect(e3)
        Duel.SpecialSummonComplete()
    else
    end
end
function c47551107.cardiansynlevel(c)
    return 4
end
function c47551107.synfilter(c,syncard,tuner,f)
    return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c47551107.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
    g:AddCard(c)
    local ct=g:GetCount()
    local res=c47551107.syngoal(g,tp,lv,syncard,minc,ct)
        or (ct<maxc and mg:IsExists(c47551107.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
    g:RemoveCard(c)
    return res
end
function c47551107.syngoal(g,tp,lv,syncard,minc,ct)
    return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
        and (g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
            or g:CheckWithSumEqual(c47551107.cardiansynlevel,lv,ct,ct,syncard))
end
function c47551107.syntg(e,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local tp=syncard:GetControler()
    local lv=syncard:GetLevel()
    if lv<=c:GetLevel() and lv<=c47551107.cardiansynlevel(c) then return false end
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c47551107.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    return mg:IsExists(c47551107.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c47551107.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
    local minc=min+1
    local maxc=max+1
    local c=e:GetHandler()
    local lv=syncard:GetLevel()
    local g=Group.FromCards(c)
    local mg=Duel.GetMatchingGroup(c47551107.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
    for i=1,maxc do
        local cg=mg:Filter(c47551107.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
        if cg:GetCount()==0 then break end
        local minct=1
        if c47551107.syngoal(g,tp,lv,syncard,minc,i) then
            if not Duel.SelectYesNo(tp,210) then break end
            minct=0
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local sg=cg:Select(tp,minct,1,nil)
        if sg:GetCount()==0 then break end
        g:Merge(sg)
    end
    Duel.SetSynchroMaterial(g)
end
function c47551107.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_PENDULUM) and c:GetPreviousControler()==tp
end
function c47551107.rtcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47551107.cfilter,1,nil,tp)
end
function c47551107.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47551107.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    local g=eg:Filter(c47551107.cfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47551107.rtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local g=eg:Filter(c47551107.cfilter,nil,tp)
        if g:GetCount()>0 then 
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
end
function c47551107.ttfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsPreviousLocation(LOCATION_DECK)
end
function c47551107.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47551107.ttfilter,1,nil)
end
function c47551107.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(c47551107.ttfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    local g=eg:Filter(c47551107.ttfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_HAND)
end
function c47551107.hspop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c47551107.ttfilter,nil,tp)
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        tc=g:GetNext()
    end
end