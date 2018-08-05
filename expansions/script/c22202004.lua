--天下翻覆？
function c22202004.initial_effect(c)
	--Act in Hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c22202004.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c22202004.target)
	e1:SetOperation(c22202004.activate)
	c:RegisterEffect(e1)
end
function c22202004.hdfilter(c)
	return c:GetMutualLinkedGroupCount()>0
end
function c22202004.handcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c22202004.hdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22202004.filter(c)
	return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c22202004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if eg:GetCount()~=1 then return false end
	local c=e:GetHandler()
	local ec=eg:GetFirst()
	if chkc then return chkc==ec end
	if chk==0 then return ec:IsType(TYPE_LINK) and ec:IsSummonType(SUMMON_TYPE_LINK) and ec:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
end
function c22202004.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local c=e:GetHandler()
	if ec:IsRelateToEffect(e) and ec:IsType(TYPE_LINK) then
		local lm=0
		if ec:IsLinkMarker(LINK_MARKER_TOP_LEFT) then lm=lm+0x001 end
		if ec:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x002 end
		if ec:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then lm=lm+0x004 end
		if ec:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
		if ec:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x040 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x080 end
		if ec:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x100 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(lm)
		ec:RegisterEffect(e1)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c22202004.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22202004.splimit(e,c)
	return c:IsType(TYPE_LINK) and (c:IsLinkMarker(LINK_MARKER_TOP) or c:IsLinkMarker(LINK_MARKER_BOTTOM))
end