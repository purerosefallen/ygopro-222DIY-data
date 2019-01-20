--超时空战斗机-R9-A
function c13257347.initial_effect(c)
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257347,5))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c13257347.sptg)
	e1:SetOperation(c13257347.spop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257347,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13257347.pccon)
	e2:SetTarget(c13257347.pctg)
	e2:SetOperation(c13257347.pcop)
	c:RegisterEffect(e2)
	--Option Control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257347,6))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetTarget(c13257347.octg)
	e4:SetOperation(c13257347.ocop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257347.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e2}
	c13257347[c]=eflist
end

function c13257347.lfilter(c,ec)
	return c:IsFaceup() and c:IsCode(13257348) and c~=ec
end
function c13257347.splimit(e,ec)
	local og=e:GetHandler():GetCardTarget()
	return not (og and og:IsExists(c13257347.lfilter,1,nil,ec))
end
function c13257347.spfilter(c,e,tp)
	return c:IsCode(13257348) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c13257347.splimit(e,c)
end
function c13257347.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13257347.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13257347.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257347.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():SetCardTarget(g:GetFirst())
	end
end
function c13257347.ocfilter(c,ec)
	return c:IsFaceup() and c:IsCode(13257348) and c:CheckEquipTarget(ec)
end
function c13257347.eqfilter(c,ec)
	return c:IsSetCard(0x3352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257347.octg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eg=e:GetHandler():GetEquipGroup()
	local og=e:GetHandler():GetCardTarget()
	local t1= (eg and eg:IsExists(c13257347.spfilter,1,nil,e,tp)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local t2= (og and og:IsExists(c13257347.ocfilter,1,nil,e:GetHandler())) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,4),aux.Stringid(13257335,5))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,4))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257335,5))+1
	end
	e:SetLabel(op)
end
function c13257347.ocop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local eg=e:GetHandler():GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=eg:FilterSelect(tp,c13257347.spfilter,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			e:GetHandler():SetCardTarget(g:GetFirst())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=eg:FilterSelect(tp,c13257347.eqfilter,1,1,nil,g:GetFirst())
			if ec then
				Duel.Equip(tp,ec,g:GetFirst())
			end
		end
	else
		local og=e:GetHandler():GetCardTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=og:FilterSelect(tp,c13257347.ocfilter,1,1,nil,e:GetHandler())
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			local sc=g:GetFirst()
			local eg=sc:GetEquipGroup()
			if eg:GetCount()>0 then
				local tc=eg:GetFirst()
				while tc do
					Duel.Equip(tp,tc,e:GetHandler(),true,true)
					tc=eg:GetNext()
				end
				Duel.Equip(tp,sc,e:GetHandler(),true,true)
				Duel.EquipComplete()
			else
				Duel.Equip(tp,sc,e:GetHandler())
			end
		end
	end
end

function c13257347.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c13257347.eqfilter1(c)
	return c:IsFaceup() and c:IsCode(13257348) and Duel.IsExistingMatchingCard(c13257347.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c13257347.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257347.pcfilter,1,nil,1-tp)
end
function c13257347.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=e:GetHandler():GetCardTarget()
	local t1=og:IsExists(c13257347.eqfilter1,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c13257347.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257347,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257347,2),aux.Stringid(13257347,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257347,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257347,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	end
end
function c13257347.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local og=e:GetHandler():GetCardTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=og:FilterSelect(tp,c13257347.eqfilter1,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,c13257347.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,sg:GetFirst())
			local tc=g:GetFirst()
			if tc then
				Duel.Equip(tp,tc,sg:GetFirst())
			end
		end
	elseif e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c13257347.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			e:GetHandler():SetCardTarget(g:GetFirst())
		end
	end
end
function c13257347.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257347,7))
end
