--圣职者之兽
function c11200038.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local val={aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK)} 
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,mg,sg) return val[i](c,fc,sub,mg,sg) and not c:IsHasEffect(6205579) end
		else
			fun[i]=function(c,fc,sub) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) end
			table.insert(mat,val[i])
		end
	end
	if #mat>0 and c.material_count==nil then
		local mt=getmetatable(c)
		mt.material_count=#mat
		mt.material=mat
	end
	local mt=getmetatable(c)
	mt.material_count=2
	mt.material=mat
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c11200038.FConditionMix(false,true,table.unpack(fun)))
	e1:SetOperation(c11200038.FOperationMix(false,true,table.unpack(fun)))
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c11200038.aclimit)
	c:RegisterEffect(e2)
	--immune (FAQ in Card Target)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11200038.etg)
	e3:SetValue(c11200038.efilter)
	c:RegisterEffect(e3)
	--mat
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(function(e,rc) return rc:IsFaceup() and rc:IsType(TYPE_RITUAL) end)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
end
function c11200038.etg(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	if c:IsFacedown() or not c:IsType(TYPE_RITUAL) then return false end
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c11200038.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c11200038.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e) and re:GetHandler():IsType(TYPE_RITUAL)
end
function c11200038.FExtraMaterialFilter(c,fc)
	return c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579) and c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionType(TYPE_RITUAL)
end
function c11200038.exzonefilter(c)
	return c:GetSequence()>4
end
function c11200038.exgfilter(c,exg)
	return exg:IsContains(c)
end
function c11200038.FConditionMix(insf,sub,...)
	local funs={...}
	return  function(e,g,gc,chkfnf)
				if g==nil then return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
				local chkf=chkfnf&0xff
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf>>8~=0
				local sub=sub or notfusion
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local exg=Duel.GetMatchingGroup(c11200038.FExtraMaterialFilter,tp,LOCATION_DECK,0,mg,c)
				if #exg>0 and mg:IsExists(c11200038.exzonefilter,1,nil) then
					mg:Merge(exg)
				end
				if gc then
					if not mg:IsContains(gc) then return false end
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMix(gc,tp,mg,sg,c,sub,chkf,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				local res=mg:IsExists(Auxiliary.FSelectMix,1,nil,tp,mg,sg,c,sub,chkf,table.unpack(funs))
				return res
			end
end
function c11200038.FOperationMix(insf,sub,...)
	local funs={...}
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=chkfnf&0xff
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=chkfnf>>8~=0
				local sub=sub or notfusion
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,table.unpack(funs))
				local exg=Duel.GetMatchingGroup(c11200038.FExtraMaterialFilter,tp,LOCATION_DECK,0,mg,c)
				if #exg>0 and mg:IsExists(c11200038.exzonefilter,1,nil) then
					mg:Merge(exg)
				end
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				while sg:GetCount()<#funs do 
					if #sg==1 and not sg:IsExists(c11200038.exzonefilter,1,nil) then
						mg:Sub(exg)
					end
					if sg:IsExists(c11200038.exgfilter,1,nil,exg) then
						mg=mg:Filter(c11200038.exzonefilter,nil)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g=mg:FilterSelect(tp,Auxiliary.FSelectMix,1,1,sg,tp,mg,sg,c,sub,chkf,table.unpack(funs))
					sg:Merge(g)
				end
				Duel.SetFusionMaterial(sg)
			end
end
