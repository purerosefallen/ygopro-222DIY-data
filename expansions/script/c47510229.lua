--漆黑的解放者 阿萨谢尔
local m=47510229
local cm=_G["c"..m]
function c47510229.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c47510229.otcon)
    e1:SetOperation(c47510229.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetRange(LOCATION_PZONE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47510229)
    e2:SetCondition(c47510229.thcon)
    e2:SetOperation(c47510229.thop)
    c:RegisterEffect(e2)    
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(c47510229.efilter2)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510229,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47510229.spcon)
    e4:SetCost(c47510229.spcost)
    e4:SetOperation(c47510229.spop)
    c:RegisterEffect(e4)
end
function c47510229.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsType(TYPE_LINK)
end
function c47510229.otfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510229.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47510229.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47510229.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47510229.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47510229.thcon(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 or not tc1:IsSetCard(0x5de) or not tc2:IsSetCard(0x5de) then return false end
    local scl1=tc1:GetLeftScale()
    local scl2=tc2:GetRightScale()
    if scl1>scl2 then scl1,scl2=scl2,scl1 end
    return scl1==1 and scl2==13
end
function c47510229.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c47510229.thop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetMatchingGroupCount(c47510229.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    local tg=Duel.GetMatchingGroup(c47510229.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    local g=nil
    if tg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510229.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47510229.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c47510229.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) or e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c47510229.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c47510229.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510229,2))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510229)
    e1:SetCondition(c47510229.pencon1)
    e1:SetOperation(c47510229.penop1)
    e1:SetValue(SUMMON_TYPE_PENDULUM)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetTarget(c47510229.eftg)
    e2:SetLabelObject(e1)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510229,2))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC_G)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,47510229)
    e3:SetCondition(c47510229.pencon2)
    e3:SetOperation(c47510229.penop2)
    e3:SetValue(SUMMON_TYPE_PENDULUM)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetTargetRange(0,LOCATION_SZONE)
    e4:SetTarget(c47510229.eftg2)
    e4:SetLabelObject(e3)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c47510229.eftg(e,c)
    return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function c47510229.eftg2(e,c)
    local rpz=Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,1)
    return c==Duel.GetFieldCard(1-e:GetHandlerPlayer(),LOCATION_PZONE,0)
        and rpz
        and c:GetFlagEffectLabel(31531170)==rpz:GetFieldID()
        and rpz:GetFlagEffectLabel(31531170)==c:GetFieldID()
end
function c47510229.penfilter(c,e,tp,lscale,rscale)
    return (c:IsSetCard(0x5da) or c:IsSetCard(0x5de)) and aux.PConditionFilter(c,e,tp,lscale,rscale)
end
function c47510229.pencon1(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if rpz==nil or c==rpz then return false end
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return false end
    local g=nil
    if og then
        g=og:Filter(Card.IsLocation,nil,loc)
    else
        g=Duel.GetFieldGroup(tp,loc,0)
    end
    return g:IsExists(c47510229.penfilter,1,nil,e,tp,lscale,rscale)
end
function c47510229.penop1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,47510229)
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ft2=Duel.GetLocationCountFromEx(tp)
    local ft=Duel.GetUsableMZoneCount(tp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then
        if ft1>0 then ft1=1 end
        if ft2>0 then ft2=1 end
        ft=1
    end
    local loc=0
    if ft1>0 then loc=loc+LOCATION_HAND end
    if ft2>0 then loc=loc+LOCATION_EXTRA end
    local tg=nil
    if og then
        tg=og:Filter(Card.IsLocation,nil,loc):Filter(c47510229.penfilter,nil,e,tp,lscale,rscale)
    else
        tg=Duel.GetMatchingGroup(c47510229.penfilter,tp,loc,0,nil,e,tp,lscale,rscale)
    end
    ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
    ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect and ect<ft2 then ft2=ect end
    while true do
        local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
        local ct=ft
        if ct1>ft1 then ct=math.min(ct,ft1) end
        if ct2>ft2 then ct=math.min(ct,ft2) end
        if ct<=0 then break end
        if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=tg:Select(tp,1,ct,nil)
        tg:Sub(g)
        sg:Merge(g)
        if g:GetCount()<ct then ft=0 break end
        ft=ft-g:GetCount()
        ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
        ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
    end
    if ft>0 then
        local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
        local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
        if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
            local ct=math.min(ft1,ft)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=tg1:Select(tp,1,ct,nil)
            sg:Merge(g)
        end
        if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
            local ct=math.min(ft2,ft)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=tg2:Select(tp,1,ct,nil)
            sg:Merge(g)
        end
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end
function c47510229.pencon2(e,c,og)
    if c==nil then return true end
    local tp=e:GetOwnerPlayer()
    local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
    if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(31531170) then return false end
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft=Duel.GetLocationCountFromEx(tp)
    if ft<=0 then return false end
    if og then
        return og:IsExists(c47510229.penfilter,1,nil,e,tp,lscale,rscale)
    else
        return Duel.IsExistingMatchingCard(c47510229.penfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
    end
end
function c47510229.penop2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
    Duel.Hint(HINT_CARD,0,31531170)
    Duel.Hint(HINT_CARD,0,47510229)
    local tp=e:GetOwnerPlayer()
    local rpz=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
    local lscale=c:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local ft=Duel.GetLocationCountFromEx(tp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect~=nil then ft=math.min(ft,ect) end
    if og then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=og:FilterSelect(tp,c47510229.penfilter,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47510229.penfilter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
        sg:Merge(g)
    end
    Duel.HintSelection(Group.FromCards(c))
    Duel.HintSelection(Group.FromCards(rpz))
end