--混沌形态·爱丽丝
function c1160006.initial_effect(c)
--
	c1160006.AddXyzProcedure(c,aux.FALSE,1,2,c1160006.filter,aux.Stringid(1160006,0))
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160006,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c1160006.tg1)
	e1:SetOperation(c1160006.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1160006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1160006.tg2)
	e2:SetOperation(c1160006.op2)
	c:RegisterEffect(e2)
--
end
--
function c1160006.filter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:GetAttack()>399
end
--
function c1160006.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	e1:SetCondition(aux.XyzCondition2(f,lv,ct,maxct,alterf,desc,op))
	e1:SetTarget(aux.XyzTarget2(f,lv,ct,maxct,alterf,desc,op))
	e1:SetOperation(c1160006.XyzOperation2(f,lv,ct,maxct,alterf,desc,op))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--
function c1160006.XyzOperation2(f,lv,minc,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					local sc=mg:GetFirst()
					local e0=Effect.CreateEffect(c)
					e0:SetType(EFFECT_TYPE_SINGLE)
					e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e0:SetValue(sc:GetOriginalAttribute())
					e0:SetReset(RESET_EVENT+0xfe0000)
					c:RegisterEffect(e0)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--
function c1160006.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	local sg=g:Filter(c1160006.ofilter1,c,e,tp)
	if sg:GetCount()>0 then
		local rec=sg:GetCount()*500
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	end
end
--
function c1160006.ofilter1(c,e,tp)
	return (c:IsControler(tp) or c:IsAbleToChangeControler()) and not (c:IsImmuneToEffect(e) or c:IsType(TYPE_TOKEN))
end
function c1160006.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	local sg=g:Filter(c1160006.ofilter1,c,e,tp)
	if sg:GetCount()<=0 then return end
	local gn=Group.CreateGroup()
	local tc=sg:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then gn:Merge(og) end
	end
	if gn:GetCount()>0 then Duel.SendtoGrave(gn,REASON_RULE) end
	Duel.Overlay(c,sg)
	Duel.Recover(tp,sg:GetCount()*550,REASON_EFFECT)
end
--
function c1160006.tfilter2_1(c,tc)
	return c:IsAttribute(tc:GetAttribute()) and c:IsAbleToGrave()
end
function c1160006.tfilter2_2(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0) then
		return c:IsSSetable()
	end
end
function c1160006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return og:FilterCount(c1160006.tfilter2_2,nil,e,tp)>0 and Duel.IsExistingMatchingCard(c1160006.tfilter2_1,tp,LOCATION_DECK,0,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_DECK)
end
--
function c1160006.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1160006.tfilter2_1,tp,LOCATION_DECK,0,1,1,nil,c)
	if g:GetCount()<=0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	local og=c:GetOverlayGroup()
	if og:GetCount()<=0 then return end
	local tg=og:Filter(c1160006.tfilter2_2,nil,e,tp)
	if tg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1160006,2))
	local gn=tg:Select(tp,1,1,nil)
	local tc=gn:GetFirst()
	if tc:IsType(TYPE_MONSTER) then 
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(1160006,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_PHASE+PHASE_END)
		e2_1:SetCountLimit(1)
		e2_1:SetLabel(fid)
		e2_1:SetLabelObject(tc)
		e2_1:SetCondition(c1160006.con2_1)
		e2_1:SetOperation(c1160006.op2_1)
		Duel.RegisterEffect(e2_1,tp)
	else
		Duel.SSet(tp,tc,1-tp)
		Duel.ConfirmCards(1-tp,tc)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2_1:SetCode(EVENT_PHASE+PHASE_END)
		e2_1:SetCountLimit(1)
		e2_1:SetLabel(fid)
		e2_1:SetLabelObject(tc)
		e2_1:SetCondition(c1160006.con2_1)
		e2_1:SetOperation(c1160006.op2_1)
		Duel.RegisterEffect(e2_1,tp)
	end
end
--
function c1160006.con2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(1160006)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c1160006.ofilter2_1(c,tc)
	return ((c:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_SZONE) and tc:IsLocation(LOCATION_SZONE))) and c:IsControler(tc:GetControler())
end
function c1160006.ofilter2_2(c,tc)
	local seq=c:GetSequence()
	return ((tc:IsLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_SZONE)) or (tc:IsLocation(LOCATION_SZONE) and c:IsLocation(LOCATION_MZONE) and seq<5)) and c:IsControler(tc:GetControler())
end
function c1160006.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_FZONE) or (tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()>4) then
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
		Duel.Destroy(tc,REASON_EFFECT)
	else
		local g=Group.CreateGroup()
		local g1=tc:GetColumnGroup(1,1)
		if g1:GetCount()>0 then
			local g1_1=tc:GetColumnGroup()
			if g1_1:GetCount()>0 then g1:Sub(g1_1) end
			local g1_2=g1:Filter(c1160006.ofilter2_1,nil,tc)
			if g1_2:GetCount()>0 then g:Merge(g1_2) end
		end
		local g2=tc:GetColumnGroup():Filter(c1160006.ofilter2_2,nil,tc)
		g:Merge(g2)
		g:AddCard(tc)
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--

