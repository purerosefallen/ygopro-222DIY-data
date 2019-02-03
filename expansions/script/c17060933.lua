--
local m=17060933
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--activate
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetDescription(aux.Stringid(m,0))
    e0:SetType(EFFECT_TYPE_IGNITION)
    e0:SetRange(LOCATION_HAND)
    e0:SetTarget(cm.sptg)
    e0:SetOperation(cm.spop)
    c:RegisterEffect(e0)
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.tecon)
	e1:SetTarget(cm.tetg)
	e1:SetOperation(cm.teop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
cm.is_named_with_Ma_Elf=1
function cm.IsMa_Elf(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Ma_Elf 
end
function cm.matfilter(c,rc)
    return c:IsCanBeRitualMaterial(rc)
end
function cm.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
    else return false end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
        local ft=Duel.GetMZoneCount(tp)
        if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
        if ft>0 then
            return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
        else
            return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
        end
    end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(m,4))
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler()
    local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
    local ft=Duel.GetMZoneCount(tp)
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function cm.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and cm.IsMa_Elf(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.GetFlagEffect(tp,m)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,0,tp,false,false)
		if g1:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.desfilter(c)
	return c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) 
	and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end